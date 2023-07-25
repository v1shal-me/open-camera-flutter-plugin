import 'opencamera_platform_interface.dart';

class Opencamera {
  Future<String?> getPlatformVersion() {
    return OpencameraPlatform.instance.getPlatformVersion();
  }

  Future<String?> capturePhoto() {
    return OpencameraPlatform.instance.capturePhoto();
  }
}
