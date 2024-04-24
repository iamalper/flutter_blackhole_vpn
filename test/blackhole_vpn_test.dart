import 'package:flutter_test/flutter_test.dart';
import 'package:blackhole_vpn/blackhole_vpn.dart';
import 'package:blackhole_vpn/blackhole_vpn_platform_interface.dart';
import 'package:blackhole_vpn/blackhole_vpn_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPerAppVpnPlatform
    with MockPlatformInterfaceMixin
    implements BlackholeVpnPlatform {
  @override
  Future<bool> runVpnService(_) async => true;

  @override
  Future<bool> isActive() {
    // TODO: implement isActive
    throw UnimplementedError();
  }

  @override
  Future<bool> stopVpnService() {
    // TODO: implement stopVpnService
    throw UnimplementedError();
  }

  @override
  // TODO: implement vpnStatusStream
  Stream<bool> get vpnStatusStream => throw UnimplementedError();
}

void main() {
  final BlackholeVpnPlatform initialPlatform = BlackholeVpnPlatform.instance;

  test('$MethodChannelBlackholeVpn is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBlackholeVpn>());
  });

  test('get Vpn instance', () async {
    MockPerAppVpnPlatform fakePlatform = MockPerAppVpnPlatform();
    BlackholeVpnPlatform.instance = fakePlatform;
    expect(await runVpnService([]), true);
  }, skip: true);
}
