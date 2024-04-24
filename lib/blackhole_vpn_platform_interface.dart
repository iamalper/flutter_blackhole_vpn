import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blackhole_vpn_method_channel.dart';

abstract class BlackholeVpnPlatform extends PlatformInterface {
  /// Constructs a [BlackholeVpnPlatform].
  BlackholeVpnPlatform() : super(token: _token);

  static final Object _token = Object();

  static BlackholeVpnPlatform _instance = MethodChannelBlackholeVpn();

  /// The default instance of [BlackholeVpnPlatform] to use.
  ///
  /// Defaults to [MethodChannelBlackholeVpn].
  static BlackholeVpnPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BlackholeVpnPlatform] when
  /// they register themselves.
  static set instance(BlackholeVpnPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Stream of vpn status changes.
  ///
  /// Stream emits `true` when vpn is active, `false` when vpn is inactive.
  Stream<bool> get vpnStatusStream;

  ///Requests permission from user then starts vpn service
  ///
  ///Returns whether user grants permission.
  ///
  ///[apps] is a list of android app's [name](https://developer.android.com/guide/topics/manifest/application-element?#nm). Eg. `com.google.youtube`
  ///
  ///It isn't safe to call from background. Calling from Isolate may be
  ///result of unknown behavior.
  Future<bool> runVpnService(List<String> apps) {
    throw UnimplementedError('runVpnService() has not been implemented.');
  }

  ///If Blackhole Vpn is active, stops it.
  ///
  ///Vpn may be stopped from user via vpn notification or system settings.
  Future<void> stopVpnService() {
    throw UnimplementedError('stopVpnService() has not been implemented.');
  }

  ///Returns if Vpn service is currently active.
  Future<bool> isActive() {
    throw UnimplementedError('isActive() has not been implemented.');
  }
}
