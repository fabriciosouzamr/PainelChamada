//@dart=2.9

import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as brendanImage;
import 'package:path_provider/path_provider.dart';

class Imagem00 {
  static Future<brendanImage.Image> getImagem(String senha) async {
/*    var imageData01 = await rootBundle.load('/assets/images/Imagem0.png');
    var imageData02 = await rootBundle.load('/assets/images/Imagem1.png');
    final image10 = brendanImage.Image.memory(imageData01.buffer.asUint8List());
    final image20 = brendanImage.Image.memory(imageData02.buffer.asUint8List());*/

    File fileimage1 = await getImageFileFromAssets('Imagem0.png');
    File fileimage2 = await getImageFileFromAssets('Imagem1.png');

    final image1 = brendanImage.decodeImage(fileimage1.readAsBytesSync());
    final image2 = brendanImage.decodeImage(fileimage2.readAsBytesSync());
    final mergedImage = brendanImage.Image(image1.width+ image2.width, max(image1.height, image2.height));
    brendanImage.copyInto(mergedImage, image1, blend: false, center: false);
    brendanImage.copyInto(mergedImage, image2, dstX: image1.width, blend: false);

    return mergedImage;
  }

  static Future<File>getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/images/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}