import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressorService {
  Future<String> compressImage(String srcPath) async {
    final targetPath = "${srcPath}_compressed.webp";
    final result = await FlutterImageCompress.compressAndGetFile(
      srcPath,
      targetPath,
      format: CompressFormat.webp,
      minHeight: 800,
      minWidth: 800,
      quality: 80,
    );
    if (result == null) throw new Exception("compress failed");
    print('src, path = $srcPath length = ${File(srcPath).lengthSync()}');
    print(
      'Compress webp result path: ${result.absolute.path}, '
      'size: ${result.lengthSync()}',
    );

    return result.absolute.path;
  }
}
