import 'package:blackhole_vpn/app_model.dart';
import 'blackhole_vpn_platform_interface.dart';
export 'app_model.dart';

///Requests permission from user then starts vpn service
///
///If user grants permission returns [true], if not returns [false]
///
///[apps] may be empty list.
///
///It isn't safe to call from background. Calling from Isolate may be
///result of unknown behaviour.
Future<bool> runVpnService(List<App> apps) =>
    PerAppVpnPlatform.instance.runVpnService(apps);

///Returns if Vpn service is currently active.
Future<bool> isActive() => PerAppVpnPlatform.instance.isActive();

///Gets installed apps with their icon, package name and name.
///
///For Android 11 (Sdk Level 30) or above some system apps maybe excluded. You can add
///```xml
///<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
///```
///to your AndroidManifest.xml to query **all** apps homever this permission restricted
///for Google Play. See more at
///[here](https://support.google.com/googleplay/android-developer/answer/9888170#package-vis).
///
///[getApps] will deprecated in future becuase it isn't a point of Blackhole Vpn.
Future<List<App>> getApps() => PerAppVpnPlatform.instance.getApps();

///If Blackhole Vpn is active, stops it.
///
///Vpn may be stopped from user via vpn notification or system settings.
Future<void> stopVpn() => PerAppVpnPlatform.instance.stopVpnService();
