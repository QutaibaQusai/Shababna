int parseLookupInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

bool parseIsActive(Object? value) => value is bool ? value : true;
