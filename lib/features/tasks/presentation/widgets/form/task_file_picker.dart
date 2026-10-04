import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/repositories/tasks_repository.dart';

class TaskFilePicker {
  const TaskFilePicker();

  static const _maxImageDimension = 2048.0;
  static const _imageQuality = 90;

  Future<List<PickedTaskFile>> pickImages(ImageSource source) async {
    final picker = ImagePicker();
    final images = source == ImageSource.camera
        ? [
            ?await picker.pickImage(
              source: ImageSource.camera,
              maxWidth: _maxImageDimension,
              maxHeight: _maxImageDimension,
              imageQuality: _imageQuality,
            ),
          ]
        : await picker.pickMultiImage(
            maxWidth: _maxImageDimension,
            maxHeight: _maxImageDimension,
            imageQuality: _imageQuality,
          );

    return [
      for (final image in images)
        PickedTaskFile(path: image.path, name: image.name, sizeBytes: await image.length()),
    ];
  }

  Future<List<PickedTaskFile>> pickDocuments(List<String> extensions) async {
    final files = await FilePicker.pickFiles(
      type: extensions.isEmpty ? FileType.any : FileType.custom,
      allowedExtensions: extensions.isEmpty ? null : extensions,
    );

    return [
      for (final file in files)
        if (file.path case final path?)
          PickedTaskFile(path: path, name: file.name, sizeBytes: await file.length() ?? 0),
    ];
  }
}
