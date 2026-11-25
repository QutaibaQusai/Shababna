enum VerificationChannel {
  phone('Phone'),
  email('Email');

  const VerificationChannel(this.apiValue);

  final String apiValue;

  static VerificationChannel? fromApi(Object? value) {
    if (value is! String) return null;
    for (final channel in values) {
      if (channel.apiValue.toLowerCase() == value.toLowerCase()) return channel;
    }
    return null;
  }
}
