import 'package:flutter_test/flutter_test.dart';
import 'package:opencamera/opencamera.dart';
import 'package:opencamera/opencamera_platform_interface.dart';
import 'package:opencamera/opencamera_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpencameraPlatform with MockPlatformInterfaceMixin implements OpencameraPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> capturePhoto() {
    // TODO: implement capturePhoto
    throw UnimplementedError();
  }
}

void main() {
  final OpencameraPlatform initialPlatform = OpencameraPlatform.instance;

  test('$MethodChannelOpencamera is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpencamera>());
  });

  test('getPlatformVersion', () async {
    Opencamera opencameraPlugin = Opencamera();
    MockOpencameraPlatform fakePlatform = MockOpencameraPlatform();
    OpencameraPlatform.instance = fakePlatform;

    expect(await opencameraPlugin.getPlatformVersion(), '42');
  });
}
