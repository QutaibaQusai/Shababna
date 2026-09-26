import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/profile_repository.dart';

class PickedAttachment {
  const PickedAttachment({required this.path, required this.sizeInBytes});

  final String path;
  final int sizeInBytes;

  bool exceeds(int megabytes) => sizeInBytes > megabytes * 1024 * 1024;
}

extension ProfileAttachmentLimits on ProfileAttachment {
  int get maxMegabytes => switch (this) {
        ProfileAttachment.picture => 5,
        ProfileAttachment.cv => 10,
        ProfileAttachment.nationalId => 5,
      };
}

class ProfileAttachmentPicker {
  const ProfileAttachmentPicker();

  static const cvExtensions = ['pdf', 'doc', 'docx'];

  Future<PickedAttachment?> pickImage(ProfileAttachment attachment, ImageSource source) async {
    final isPicture = attachment == ProfileAttachment.picture;
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: isPicture ? 1024 : 2048,
      maxHeight: isPicture ? 1024 : 2048,
      imageQuality: isPicture ? 85 : 90,
      preferredCameraDevice: isPicture ? CameraDevice.front : CameraDevice.rear,
    );
    if (file == null) return null;
    return PickedAttachment(path: file.path, sizeInBytes: await file.length());
  }

  Future<PickedAttachment?> pickDocument() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: cvExtensions,
    );
    final path = file?.path;
    if (file == null || path == null) return null;
    return PickedAttachment(path: path, sizeInBytes: await file.length() ?? 0);
  }
}
