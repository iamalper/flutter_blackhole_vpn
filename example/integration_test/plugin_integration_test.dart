// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:blackhole_vpn/blackhole_vpn.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

/*  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final PerAppVpn plugin = PerAppVpn();
    final bool isVpnOn = await plugin.runVpnService();

    expect(isVpnOn, true);
  });*/
}
