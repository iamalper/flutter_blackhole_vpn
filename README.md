Blackhole Vpn sets up a vpn client for prevent connections for selected apps.

Android has VpnManager api and it is possible to create a vpn connection for specified apps. With this plugin, selected apps network will managed by a dummy vpn which don't make any connection.

**Does not** require root.

## Supported platforms

- Android

Any PR for other platforms is appreciated

## Use cases

Firewall apps, data saving apps

## How to use

> This plugin uses `BIND_VPN_SERVICE` permission for setting up
> vpnservice.
>
> If you want to publish your app to Google Play Store you need to document the
> use of vpnservice at store listing. See more at
> [here](https://support.google.com/googleplay/android-developer/answer/9888170#vpn)

No need to edit _AndroidManifest.xml_

Make sure to minimum sdk version is 21 or above in _android/app/build.gradle_

```gradle
defaultConfig {
    minSdkVersion 21
}
```

#### Import the package

All the methods below are available after importing the package and getting the instance of the plugin.

```dart
import 'package:blackhole_vpn/blackhole_vpn.dart';
final blackholeVpn = BlackholeVpnPlatform.instance;
```

#### Start Vpn for specified apps

You have to know package names for the apps do you want to use the blackhole
vpn. Example app uses
[android_package_manager](https://pub.dev/packages/android_package_manager)
plugin.

```dart
 //Request permission then start blackhole vpn for specified apps
await blackholeVpn.runVpnService(["com.google.youtube","com.android.chrome"]);
```

Specified apps will not able to connect internet and local network. Returns
`bool` whether the user accepted permission.

#### Check if blackhole vpn active

```dart
await blackholeVpn.isActive(); //Returns bool
```

#### Stop blackhole vpn

```dart
await blackholeVpn.stopVpn(); //Alternatively user can stop it via vpn notification or system settings
```

#### Tracking vpn state changes

Android let users to start or stop vpn service via vpn notification or system settings. You can track vpn state changes with specified methods.

- Using `VpnStateObserver` widget

  ```dart
  VpnStateObserver(
      builder: (isActive) => switch (isActive) {
              true => Text("Blackhole vpn active"),
              false => Text(
                  "Blackhole vpn not active"),
              null => Text("Loading")
          })
  ```

- Listening `vpnStatusStream`

  ```dart
  blackholeVpn.vpnStatusStream.listen((isActive) {
      if (isActive) {
          print("Blackhole vpn active");
      } else {
          print("Blackhole vpn not active");
      }
  });
  ```

  `vpnStatusStream` is a broadcast stream, it can be listened multiple times. It may not emit any value if vpn state is not changed. Checking state with `isActive()` before listen is recommended.

## Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:blackhole_vpn/blackhole_vpn.dart';
import 'package:blackhole_vpn/blackhole_vpn_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class TestBlackholeVpnPlatform
    with MockPlatformInterfaceMixin
    implements BlackholeVpnPlatform {
  var _isActive = false;
  @override
  Future<bool> runVpnService(_) async {
    _isActive = true;
    return true;
  }

  @override
  Future<bool> isActive() async {
    return _isActive;
  }

  @override
  Future<void> stopVpnService() async {
    _isActive = false;
  }

  @override
  Stream<bool> getVpnStatusStream() => throw UnimplementedError();
}

void main() {
  BlackholeVpnPlatform.instance = TestBlackholeVpnPlatform();
  test('test runVpnService', () async {
    final blackholeVpn = BlackholeVpnPlatform.instance;
    expect(await blackholeVpn.runVpnService([]), isTrue);
    expect(await blackholeVpn.isActive(), isTrue);
  });
}
```
