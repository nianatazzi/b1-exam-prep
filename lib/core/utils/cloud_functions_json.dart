// На Android cloud_functions отдаёт вложенные map/list как Map<Object?, Object?> —
// поверхностный Map<String, dynamic>.from() чинит только верхний уровень, а
// вложенные map внутри generated fromJson падают с TypeError на непустом
// списке. Рекурсивно приводим все вложенные map к Map<String, dynamic> перед
// парсингом. Общий хелпер для всех callable Cloud Functions в b1_exam
// (analyzeSpeech, continueDialogue, ...).
Map<String, dynamic> deepStringKeyedMap(Map<Object?, Object?> map) =>
    map.map((key, value) => MapEntry(key.toString(), _deepConvert(value)));

dynamic _deepConvert(dynamic value) {
  if (value is Map) {
    return deepStringKeyedMap(Map<Object?, Object?>.from(value));
  }
  if (value is List) {
    return value.map(_deepConvert).toList();
  }
  return value;
}
