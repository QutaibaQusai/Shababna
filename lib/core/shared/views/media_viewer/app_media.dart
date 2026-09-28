sealed class AppMedia {
  const AppMedia(this.url);

  final String url;
}

class AppImageMedia extends AppMedia {
  const AppImageMedia(super.url);
}

class AppVideoMedia extends AppMedia {
  const AppVideoMedia(super.url, {required this.isExternal});

  final bool isExternal;
}
