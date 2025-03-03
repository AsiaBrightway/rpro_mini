import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

///compress image file size
Future<File?> compressAndGetFile(File file, String targetPath,int quality) async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

  // Define the target path for the compressed file
  String targetPath = '$tempPath/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
  try {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      rotate: 0,
    );
    return result != null ? File(result.path) : null;
  } catch (e) {
    return null;
  }
}