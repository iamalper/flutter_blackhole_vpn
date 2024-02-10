import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:blackhole_vpn/blackhole_vpn.dart';
import 'package:android_package_manager/android_package_manager.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Add this for using flutter plugin before runApp()
  final isVpnActive = await isActive(); //Get if vpn active or not

  //In example app, we use a flutter plugin from here: https://pub.dev/packages/android_package_manager
  final installedApps =
      await AndroidPackageManager().getInstalledApplications();

  //Using [Set] instead [List] because same app names may repeat.
  final installedAppsNames = {
    for (final app in installedApps!)
      if (app.name != null) app.name!
  };

  runApp(MyApp(
    isVpnActive: isVpnActive,
    installedAppNames: installedAppsNames.toList(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key, required this.isVpnActive, required this.installedAppNames});
  final bool isVpnActive;
  final List<String> installedAppNames;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late var _isVpnOn = widget.isVpnActive;

  //The selected apps for pass to blackhole vpn
  final _selectedApps = <String>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blackhole Vpn Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isVpnOn
                ? "Blackhole vpn active"
                : "Select the apps which you want to prevent to connect internet"),
            Expanded(
              child: ListView.builder(
                itemCount: widget.installedAppNames.length,
                itemBuilder: (context, index) {
                  final appName = widget.installedAppNames[index];
                  return SwitchListTile(
                    title: Text(appName),
                    value: _selectedApps.contains(appName),
                    onChanged: (bool value) {
                      if (value) {
                        setState(() {
                          _selectedApps.add(appName);
                        });
                      } else {
                        setState(() {
                          _selectedApps.remove(appName);
                        });
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: _isVpnOn
                    ? () async {
                        await stopVpn(); //Stop Blackhole Vpn
                        setState(() {
                          _isVpnOn = false;
                        });
                      }
                    : () async {
                        //Start vpn service
                        final isActivated = await runVpnService(_selectedApps);
                        if (isActivated) {
                          //Vpn permission granted
                          setState(() {
                            _isVpnOn = true;
                          });
                        } else {
                          //Vpn permission not granted
                          log("Vpn permission not granted");
                        }
                      },
                child: Text(
                    _isVpnOn ? "Stop Blackhole Vpn" : "Start Blackhole Vpn"))
          ],
        ),
      ),
    );
  }
}
