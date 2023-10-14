import 'package:blackhole_vpn/app_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blackhole_vpn_platform_interface.dart';

/// An implementation of [PerAppVpnPlatform] that uses method channels.
class MethodChannelPerAppVpn implements PerAppVpnPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blackhole_vpn');

  @override
  Future<bool> runVpnService(List<App> apps) async =>
      (await methodChannel.invokeMethod<bool>("startVpn",
          {"allowedApps": apps.map((e) => e.packageName).toList()}))!;

  @override
  Future<bool> isActive() async =>
      (await methodChannel.invokeMethod<bool>("getStatus"))!;

  @override
  Future<void> stopVpnService() => methodChannel.invokeMethod<void>("stopVpn");

  @override
  Future<List<App>> getApps() async {
    final appsMap = (await methodChannel.invokeListMethod<Map>("getApps"))!;
    return appsMap
        .map((e) => App(e["name"], e["packageName"]!, e["icon"]!))
        .toList();
  }
}
