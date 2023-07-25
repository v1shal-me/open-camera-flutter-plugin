import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'opencamera_platform_interface.dart';

class MethodChannelOpencamera extends OpencameraPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('opencamera');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> capturePhoto() async {
    final imagePath = await methodChannel.invokeMethod<String>('capturePhoto');
    return imagePath;
  }
}
