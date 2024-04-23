// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:typed_data';

import 'rangoprint_platform_interface.dart';
import 'size.dart';

class Rangoprint {
  Future<String?> getPlatformVersion() {
    return RangoprintPlatform.instance.getPlatformVersion();
  }

  Future<void> print(String text, {PrintSize? size}) {
    if (size == null || size == PrintSize.small) {
      return RangoprintPlatform.instance.print(text, "small");
    }
    switch (size) {
      case PrintSize.normal:
        return RangoprintPlatform.instance.print(text, "normal");
      case PrintSize.bold:
        return RangoprintPlatform.instance.print(text, "bold");
      case PrintSize.custom:
        return RangoprintPlatform.instance.print(text, "custom");
      default:
        return RangoprintPlatform.instance.print(text, "small");
    }
  }

  Future<void> cut(CutSize type) {
    if (type == CutSize.short) {
      return RangoprintPlatform.instance.cut("short_cut");
    }
    return RangoprintPlatform.instance.cut("larger_cut");
  }

  Future<void> printBitmap(dynamic imageData) {
    return RangoprintPlatform.instance.printBitmap(imageData);
  }
}
