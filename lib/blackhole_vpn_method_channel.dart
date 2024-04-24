import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blackhole_vpn_platform_interface.dart';

/// An implementation of [BlackholeVpnPlatform] that uses method channels.
class MethodChannelBlackholeVpn implements BlackholeVpnPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blackhole_vpn');
  @visibleForTesting
  final eventStatusChange = const EventChannel("blackhole_vpn_status_change");

  @override
  Stream<bool> get vpnStatusStream => eventStatusChange
      .receiveBroadcastStream()
      .map((event) => switch (event) { bool _ => event, _ => throw Error() });

  @override
  Future<bool> runVpnService(List<String> apps) async => (await methodChannel
      .invokeMethod<bool>("startVpn", {"allowedApps": apps}))!;

  @override
  Future<bool> isActive() async =>
      (await methodChannel.invokeMethod<bool>("getStatus"))!;

  @override
  Future<void> stopVpnService() => methodChannel.invokeMethod<void>("stopVpn");
}
