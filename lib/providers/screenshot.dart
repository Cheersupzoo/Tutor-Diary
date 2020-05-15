import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:share/share.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class Screenshot {
  GlobalKey previewContainer;
  String id;

  Screenshot({@required this.previewContainer, @required this.id});

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    ///////For Debug ONLY!!!
    //print(boundary.debugNeedsPaint);
    /* if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    } */

    var image = await boundary.toImage(pixelRatio: 4);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  takeScreenShot() async {
    var pngBytes = await _capturePng();
    var bs64 = base64Encode(pngBytes);
    final directory = (await getApplicationDocumentsDirectory()).path;
    print(pngBytes);

    if (await Permission.storage.request().isGranted) {
      //File imgFile = new File('$directory/screenshot-$id.png');

      final result = await ImageGallerySaver.saveImage(pngBytes.buffer.asUint8List());
      //print(result);
      //await imgFile.writeAsBytes(pngBytes);
      //FlutterShareFile.shareImage(imgFile.toString(), 'screenshot-$id.png');

      
      await WcFlutterShare.share(
          sharePopupTitle: 'Share image to',
          fileName: 'screenshot-$id.png',
          mimeType: 'image/png',
          bytesOfFile: pngBytes.buffer.asUint8List());

      //await Share.shareFile(imgFile);
      //await imgFile.delete();
    } else {
      print("Permission Error!");
    }
  }
}
