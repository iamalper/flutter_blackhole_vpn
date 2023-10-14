Blackhole Vpn sets up a vpn for prevent connections for selected apps.

Selected apps network will managed by a dummy vpn which don't make any connection.

## Supported platforms
- Android

Any PR for other platforms is appreciated

## Use cases
Firewall apps, data saving apps

## How to use
> [!WARNING]
> This plugin uses `BIND_VPN_SERVICE` permission for setting up vpnservice. 
> 
> If you want to publish your app to Google Play Store you need to document the use of vpnservice at store listing. See more at [here](https://support.google.com/googleplay/android-developer/answer/9888170#vpn)

Make sure to minimum sdk version is 21 or above in *android/app/build.gradle*
```gradle
defaultConfig {
    minSdkVersion 21
}
```
The methods available:
#### Get installed applications with their name, package name and icon
```dart
final apps = await getApps(); //Get installed apps
```
> [!WARNING]
> For Android 11 (Sdk Level 30) or above some system apps maybe excluded. You can add
> ```xml
> <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
> ```
> to your AndroidManifest.xml to query **all** apps homever this permission restricted for Google Play. See more at
> [here](https://support.google.com/googleplay/android-developer/answer/9888170#package-vis).

> [!WARNING]
> `getApps()` will be deprecated in future because app querying isn't this package's point.
#### Start Vpn for specified apps
```dart
await runVpnService(apps); //Request permission then start blackhole vpn for [apps]
```
`apps` will not able to connect internet and local network. Returns `bool` is the user accepted permission or not.

#### Check if blackhole vpn active
```dart
await isActive(); //Returns bool
```
#### Stop blackhole vpn
```dart
await stopVpn(); //Alternatively user can stop it via vpn notification or system settings
```