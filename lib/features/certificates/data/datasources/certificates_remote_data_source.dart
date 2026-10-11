import 'dart:io';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/certificate_model.dart';

class CertificatesRemoteDataSource {
  CertificatesRemoteDataSource(this._apiConsumer);

  static const _downloadFolder = 'shababna';
  static final _unsafeFileNameChars = RegExp(r'[^A-Za-z0-9_-]');

  final ApiConsumer _apiConsumer;

  Future<PagedResult<CertificateModel>> getCertificates({
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.certificates,
      queryParameters: {'Page': page, 'PageSize': pageSize},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, CertificateModel.fromJson);
  }

  Future<CertificateModel> getCertificate(String id) async {
    final response = await _apiConsumer.get(EndPoints.certificateById(id));
    return CertificateModel.fromJson(response as Map<String, dynamic>);
  }

  Future<String> downloadDocument({
    required String documentUrl,
    required String certificateNumber,
    required String languageCode,
  }) async {
    final directory = Directory('${Directory.systemTemp.path}/$_downloadFolder');
    if (!await directory.exists()) await directory.create(recursive: true);
    final safeNumber = certificateNumber.replaceAll(_unsafeFileNameChars, '_');
    final file = File('${directory.path}/certificate_${safeNumber}_$languageCode.pdf');

    try {
      await _apiConsumer.download(documentUrl, file.path);
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    }
    return file.path;
  }
}
