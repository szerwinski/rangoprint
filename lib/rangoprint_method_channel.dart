import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rangoprint_platform_interface.dart';

/// An implementation of [RangoprintPlatform] that uses method channels.
class MethodChannelRangoprint extends RangoprintPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rangoprint');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  
  @override
  Future<void> print(String text, String size) async  {
    await methodChannel.invokeMethod<void>(size, <String, dynamic>{
      "text": text
    });
  }

  @override
  Future<void> cut(String type) async {
    await methodChannel.invokeMethod<void>(type);
  }

  @override
  Future<void> printBitmap(dynamic imageData) async {
    await methodChannel.invokeMethod<void>("bitmap", <String, dynamic>{
      "imagedata": imageData
    });
  }
}
