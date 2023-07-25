import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'opencamera_method_channel.dart';

abstract class OpencameraPlatform extends PlatformInterface {
  /// Constructs a OpencameraPlatform.
  OpencameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpencameraPlatform _instance = MethodChannelOpencamera();

  /// The default instance of [OpencameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpencamera].
  static OpencameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpencameraPlatform] when
  /// they register themselves.
  static set instance(OpencameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> capturePhoto() {
    throw UnimplementedError('capturePhoto() has not been implemented.');
  }
}
