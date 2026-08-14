# B1 image_description seed script

One-off script to load test content for the image_description Phase 1 flow
(one topic: verb conjugation + noun declension + phrase + matching exercises).

## Setup

1. Firebase Console → Project settings → Service accounts → **Generate new
   private key**. Save the downloaded file as `scripts/seed/serviceAccountKey.json`
   (already gitignored — never commit it, it grants full admin access).
2. `cd scripts/seed && npm install`

## Run

```
node seed.js
```

Re-running is safe — all documents use fixed IDs (`set()`, not `add()`), so it
overwrites the same content instead of duplicating it.

## Edit content

Change `seed-data.json` and re-run. Structure:
- `sections[].topics[].grammar[]` — rule_type `"conjugation"` (verb) or
  `"declension"` (noun). Exercises reference these via `linked_item_id` = `g_id`.
- `sections[].topics[].phrases[]`
- `exercises[]` — flat list, root `exercises` collection.
