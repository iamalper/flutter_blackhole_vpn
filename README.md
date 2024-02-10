Blackhole Vpn sets up a vpn for prevent connections for selected apps.

Selected apps network will managed by a dummy vpn which don't make any
connection.

## Supported platforms

- Android

Any PR for other platforms is appreciated

## Use cases

Firewall apps, data saving apps

## How to use

> [!WARNING] This plugin uses `BIND_VPN_SERVICE` permission for setting up
> vpnservice.
>
> If you want to publish your app to Google Play Store you need to document the
> use of vpnservice at store listing. See more at
> [here](https://support.google.com/googleplay/android-developer/answer/9888170#vpn)

Make sure to minimum sdk version is 21 or above in _android/app/build.gradle_

```gradle
defaultConfig {
    minSdkVersion 21
}
```

#### Start Vpn for specified apps

You have to know package names for the apps do you want to use the blackhole
vpn. Example app uses
[android_package_manager](https://pub.dev/packages/android_package_manager)
plugin.

```dart
 //Request permission then start blackhole vpn for specified apps
await runVpnService(["com.google.youtube","com.android.chrome"]);
```

Specified apps will not able to connect internet and local network. Returns
`bool` whether the user accepted permission or not.

#### Check if blackhole vpn active

```dart
await isActive(); //Returns bool
```

#### Stop blackhole vpn

```dart
await stopVpn(); //Alternatively user can stop it via vpn notification or system settings
```
