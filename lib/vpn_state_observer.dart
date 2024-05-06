import 'dart:async';

import 'package:blackhole_vpn/blackhole_vpn.dart';
import 'package:blackhole_vpn/blackhole_vpn_platform_interface.dart';
import 'package:flutter/cupertino.dart';

///A helper widget that updates it's state when vpn state changed by any means.
class VpnStateObserver extends StatefulWidget {
  final Widget Function(bool? isActive) builder;

  final BlackholeVpnPlatform? instance;

  ///[builder] executed when [isActive] changed.
  ///
  ///[isActive] maybe `null` for a short time because vpn state updates asynchronous.
  ///Use this for loading animations.
  ///
  ///When [instance] is `null`, default [BlackholeVpnPlatform] instance used.
  ///Set a custom [BlackholeVpnPlatform] instance for testing.
  const VpnStateObserver({super.key, required this.builder, this.instance});

  @override
  State<VpnStateObserver> createState() => _VpnStateObserverState();
}

class _VpnStateObserverState extends State<VpnStateObserver> {
  late final instance = widget.instance ?? BlackholeVpnPlatform.instance;
  late final vpnStatusStream = instance.getVpnStatusStream();
  late final childBuilder = widget.builder;
  Future<void>? firstCheckFuture;
  StreamSubscription<bool>? statusSubscription;

  bool? isActive;
  set active(bool active) {
    if (mounted) {
      setState(() {
        isActive = active;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    instance.isActive().then((value) => active = value);
    vpnStatusStream.listen((event) => active = event);
  }

  @override
  void dispose() {
    firstCheckFuture?.ignore();
    statusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return childBuilder(isActive);
  }
}
