enum AuthStatus {
  authenticated,
  guest,
  unauthenticated;

  bool get isAuthenticated => this == authenticated;

  bool get isGuest => this == guest;
}
