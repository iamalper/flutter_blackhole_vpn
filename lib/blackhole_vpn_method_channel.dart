import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blackhole_vpn_platform_interface.dart';

/// An implementation of [PerAppVpnPlatform] that uses method channels.
class MethodChannelPerAppVpn implements PerAppVpnPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blackhole_vpn');

  @override
  Future<bool> runVpnService(List<String> apps) async => (await methodChannel
      .invokeMethod<bool>("startVpn", {"allowedApps": apps}))!;

  @override
  Future<bool> isActive() async =>
      (await methodChannel.invokeMethod<bool>("getStatus"))!;

  @override
  Future<void> stopVpnService() => methodChannel.invokeMethod<void>("stopVpn");
}
