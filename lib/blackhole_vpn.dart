import 'blackhole_vpn_platform_interface.dart';

///Requests permission from user then starts vpn service
///
///Returns whether user grants permission.
///
///[apps] is a list of android app's [name](https://developer.android.com/guide/topics/manifest/application-element?#nm). Eg. `com.google.youtube`
///
///It isn't safe to call from background. Calling from Isolate may be
///result of unknown behavior.
Future<bool> runVpnService(List<String> apps) =>
    PerAppVpnPlatform.instance.runVpnService(apps);

///Returns if Vpn service is currently active.
Future<bool> isActive() => PerAppVpnPlatform.instance.isActive();

///If Blackhole Vpn is active, stops it.
///
///Vpn may be stopped from user via vpn notification or system settings.
Future<void> stopVpn() => PerAppVpnPlatform.instance.stopVpnService();
