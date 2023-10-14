import 'package:flutter_test/flutter_test.dart';
import 'package:blackhole_vpn/blackhole_vpn.dart';
import 'package:blackhole_vpn/blackhole_vpn_platform_interface.dart';
import 'package:blackhole_vpn/blackhole_vpn_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPerAppVpnPlatform
    with MockPlatformInterfaceMixin
    implements PerAppVpnPlatform {
  @override
  Future<bool> runVpnService(_) async => true;

  @override
  Future<List<App>> getApps() {
    // TODO: implement getApps
    throw UnimplementedError();
  }

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
}

void main() {
  final PerAppVpnPlatform initialPlatform = PerAppVpnPlatform.instance;

  test('$MethodChannelPerAppVpn is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPerAppVpn>());
  });

  test('get Vpn instance', () async {
    MockPerAppVpnPlatform fakePlatform = MockPerAppVpnPlatform();
    PerAppVpnPlatform.instance = fakePlatform;
    expect(await runVpnService([]), true);
  }, skip: true);
}
