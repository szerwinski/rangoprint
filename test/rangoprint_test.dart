import 'package:flutter_test/flutter_test.dart';
import 'package:rangoprint/rangoprint.dart';
import 'package:rangoprint/rangoprint_platform_interface.dart';
import 'package:rangoprint/rangoprint_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRangoprintPlatform
    with MockPlatformInterfaceMixin
    implements RangoprintPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RangoprintPlatform initialPlatform = RangoprintPlatform.instance;

  test('$MethodChannelRangoprint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRangoprint>());
  });

  test('getPlatformVersion', () async {
    Rangoprint rangoprintPlugin = Rangoprint();
    MockRangoprintPlatform fakePlatform = MockRangoprintPlatform();
    RangoprintPlatform.instance = fakePlatform;

    expect(await rangoprintPlugin.getPlatformVersion(), '42');
  });
}
