import 'package:blackhole_vpn/app_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blackhole_vpn_method_channel.dart';

abstract class PerAppVpnPlatform extends PlatformInterface {
  /// Constructs a PerAppVpnPlatform.
  PerAppVpnPlatform() : super(token: _token);

  static final Object _token = Object();

  static PerAppVpnPlatform _instance = MethodChannelPerAppVpn();

  /// The default instance of [PerAppVpnPlatform] to use.
  ///
  /// Defaults to [MethodChannelPerAppVpn].
  static PerAppVpnPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PerAppVpnPlatform] when
  /// they register themselves.
  static set instance(PerAppVpnPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> runVpnService(List<App> apps) {
    throw UnimplementedError('runVpnService() has not been implemented.');
  }

  Future<void> stopVpnService() {
    throw UnimplementedError('stopVpnService() has not been implemented.');
  }

  Future<bool> isActive() {
    throw UnimplementedError('isActive() has not been implemented.');
  }

  Future<List<App>> getApps() {
    throw UnimplementedError('getApps() has not been implemented.');
  }
}
