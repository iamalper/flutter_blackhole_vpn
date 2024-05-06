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
