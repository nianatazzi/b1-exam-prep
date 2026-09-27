# Wiring the ai-keys-shop LLM gateway into a Python project

Hand-off guide. Everything below was verified against the live gateway in production
(Cloud Run + local), including the failure modes. Adapt the code to the target project's
architecture; the constraints and quirks are the important part.

---

## 1. What the gateway is

A third-party multi-model proxy that speaks **both** the OpenAI and Anthropic wire protocols
with one key.

| | value |
|---|---|
| OpenAI-compatible base | `https://api.ai-keys-shop.com/v1` |
| Anthropic-compatible base | `https://api.ai-keys-shop.com` |
| Key | one `sk-...` works for both |

**Use the OpenAI SDK against the `/v1` base.** One client, one code path, switch models by
string. Do not reach for the Anthropic SDK unless something specifically requires it.

```python
from openai import OpenAI
client = OpenAI(api_key=os.getenv("GATEWAY_API_KEY"),
                base_url="https://api.ai-keys-shop.com/v1")
```

Requires `openai>=2.49,<3` and `python-dotenv`. No gateway-specific package exists or is needed.

---

## 2. Models actually available

Check at runtime — the catalog is account-specific:

```python
sorted(m.id for m in client.models.list().data)
```

On the verified account (`claude-code` distributor group):

- `claude-haiku-4-5`, `claude-haiku-4-5-20251001` — **text, works**
- `claude-opus-5` — text
- `gpt-image-2` — **listed but NOT serviceable**: returns
  `503 model_not_found: "No available channel for model gpt-image-2 under group <group>"`
- **No TTS model at all** — this is a hard constraint of the gateway.

**Critical distinction:** `/v1/models` returns the *catalog*. A model can be listed yet have no
upstream "channel" bound to your token's group, which fails only at call time. Always test an
actual call, never trust the listing.

---

## 3. The five quirks that will bite you

### 3.1 Use `chat.completions`, never `responses.create`
The Responses API's strict `json_schema` structured output is not honored by the Claude shim.
Use chat completions with `response_format={"type": "json_object"}`, put the JSON schema **in the
prompt**, and validate the result yourself.

### 3.2 JSON comes back wrapped in markdown fences
Even in `json_object` mode the model returns:
```
```json
{"ok": true}
```
```
A bare `json.loads()` fails with `Expecting value: line 1 column 1 (char 0)`. Strip fences and
fall back to extracting the outermost `{...}`:

```python
_FENCE_RE = re.compile(r"^\s*```(?:json)?\s*|\s*```\s*$", re.IGNORECASE)

def loads_lenient(raw: str):
    text = _FENCE_RE.sub("", raw.strip())
    try:
        return json.loads(text)
    except json.JSONDecodeError as e1:
        start, end = text.find("{"), text.rfind("}")
        if start != -1 and end > start:
            try:
                return json.loads(text[start:end + 1])
            except json.JSONDecodeError as e2:
                raise ValueError(f"invalid JSON ({e2}): {raw[:300]!r}") from e2
        raise ValueError(f"invalid JSON ({e1}): {raw[:300]!r}") from e1
```

### 3.3 `max_tokens` is required
Claude models require it. Always pass it explicitly on every chat call.

### 3.4 Malformed JSON happens intermittently — retry
Haiku behind the shim occasionally emits genuinely broken JSON (e.g. `Expecting ':' delimiter`)
on larger batches. **Resample up to ~3 times**; a fresh sample almost always parses. Separately
check `finish_reason == "length"` — that means truncation, which retrying at the same budget can
never fix, so fail fast with a message naming the limit. Keep per-request batches modest.

### 3.5 `APIConnectionError("Connection error.")` hides the real cause
The OpenAI SDK wraps *every* transport-layer exception into this one useless message. The actual
error is in `__cause__` — always log it:

```python
except APIConnectionError as e:
    cause = e.__cause__
    print(f"{type(e).__name__}: {e} — caused by {type(cause).__name__}: {cause}")
```

**Most common real cause: a corrupted key.** A trailing newline in the secret makes the auth
header invalid and surfaces as this generic connection error. In PowerShell, `"key" | cmd
--data-file=-` appends a newline — write the file with `[IO.File]::WriteAllText(path, "key")`
instead, and verify the stored length matches the key exactly.

---

## 4. Minimal working call

```python
def call_structured(prompt: str, schema: dict, schema_name: str,
                    max_tokens: int = 2000, attempts: int = 3) -> dict:
    system = ("You are a precise JSON generator. Respond with a SINGLE JSON object conforming to "
              "the schema. Output only the JSON object — no markdown fences, no commentary.\n"
              f"JSON schema ({schema_name}):\n{json.dumps(schema)}")

    last = None
    for i in range(1, attempts + 1):
        resp = client.chat.completions.create(
            model=os.getenv("GATEWAY_TEXT_MODEL", "claude-haiku-4-5"),
            max_tokens=max_tokens,                       # required
            response_format={"type": "json_object"},     # not json_schema
            messages=[{"role": "system", "content": system},
                      {"role": "user", "content": prompt}],
        )
        choice = resp.choices[0]
        if choice.finish_reason == "length":
            raise ValueError(f"truncated at {max_tokens} tokens — raise the budget or shrink input")
        try:
            data = loads_lenient(choice.message.content or "")
            missing = [k for k in schema.get("required", []) if k not in data]
            if missing:
                raise ValueError(f"missing keys {missing}")
            return data
        except ValueError as e:
            last = e
            print(f"bad JSON attempt {i}/{attempts}: {e}")
    raise last
```

---

## 5. Recommended: provider failover instead of a hardcoded client

Do not hardcode the gateway. Define an ordered list of providers, use the first with a key
present, and fall through on provider-level failures. This lets native OpenAI serve while it has
funds and the gateway take over when it doesn't — and makes adding a third provider one entry.

```python
SPECS = [
  {"name": "openai",       "base_url": None,  # SDK default
   "key_env": "OPENAI_API_KEY",
   "models": {"text": "gpt-4o-mini", "image": "gpt-image-1"}},
  {"name": "ai-keys-shop", "base_url": "https://api.ai-keys-shop.com/v1",
   "key_env": "GATEWAY_API_KEY",
   "models": {"text": "claude-haiku-4-5", "image": "gpt-image-2"}},
]

# Fall through ONLY on these — "this provider can't serve it right now":
FAILOVER = (AuthenticationError, PermissionDeniedError, RateLimitError,   # RateLimit = out of funds
            APIConnectionError, APITimeoutError, InternalServerError)
# NOT BadRequestError/NotFoundError — those are your own bug or a genuinely
# unsupported model, and must surface instead of being silently masked.
```

Skip a spec whose key is absent (not an error). Select models per **task** (`text`, `image`, …),
not one global constant, so tasks can use different models/providers.

---

## 6. Capability gaps to design around

- **No TTS.** If the project generates audio, make it optional: return `None` on failure, never
  raise, and let downstream records carry a null audio field. TTS must be a separate integration
  (OpenAI `tts-1`/`gpt-4o-mini-tts`, ElevenLabs, Azure, Google) — it never routes through this
  gateway.
- **Images unreliable.** Treat image generation as optional the same way. Also handle both
  response shapes: native OpenAI returns `b64_json`, a gateway may return `url`.
- **General rule:** an optional-media failure must never discard the text content that was already
  generated (and paid for) for that item.

---

## 7. Ship a smoke test

Before any bulk run, probe **each provider individually** (not through the failover chain, or one
provider silently covers for another). Parse the response with the *same* lenient parser the real
code uses — a stricter probe will false-fail on fenced JSON. Report per provider: ok/fail,
latency, model, and the error. Keep text probes cheap; make image/audio probes opt-in flags.

If the code runs somewhere remote (Cloud Run, CI), also expose a diagnostic that probes, **from
inside that environment**, in layers: DNS → TCP/TLS → plain HTTPS GET `/v1/models` → the real SDK
call. A failure that reproduces only remotely cannot be diagnosed from a laptop, and layering
tells you instantly whether it's egress, TLS, auth, or the key. Report the key's *length* (never
the key) to catch whitespace corruption.

---

## 8. Secrets

One key grants spend on both endpoints. Keep it in env/secret manager, never committed. Verify
the stored value has no trailing whitespace (see 3.5). If deploying to a container platform, also
confirm your build-context ignore file excludes `.env` — `.dockerignore` does not govern
`gcloud builds submit`; `.gcloudignore` does.
