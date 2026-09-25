class SocialMediaLinksModel {
  const SocialMediaLinksModel({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.threads,
    required this.snapchat,
    required this.linkedIn,
    required this.tikTok,
    required this.youTube,
  });

  factory SocialMediaLinksModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinksModel(
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      instagram: json['instagram'] as String?,
      threads: json['threads'] as String?,
      snapchat: json['snapchat'] as String?,
      linkedIn: json['linkedIn'] as String?,
      tikTok: json['tikTok'] as String?,
      youTube: json['youTube'] as String?,
    );
  }

  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? threads;
  final String? snapchat;
  final String? linkedIn;
  final String? tikTok;
  final String? youTube;
}
