import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rangoprint_method_channel.dart';

abstract class RangoprintPlatform extends PlatformInterface {
  /// Constructs a RangoprintPlatform.
  RangoprintPlatform() : super(token: _token);

  static final Object _token = Object();

  static RangoprintPlatform _instance = MethodChannelRangoprint();

  /// The default instance of [RangoprintPlatform] to use.
  ///
  /// Defaults to [MethodChannelRangoprint].
  static RangoprintPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RangoprintPlatform] when
  /// they register themselves.
  static set instance(RangoprintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
  Future<void> print(String text, String size) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  } 

  Future<void> cut(String type) {
  throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> printBitmap(dynamic imageData) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
