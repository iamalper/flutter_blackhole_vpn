import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blackhole_vpn/blackhole_vpn_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ignore: unused_local_variable
  MethodChannelPerAppVpn platform = MethodChannelPerAppVpn();
  const MethodChannel channel = MethodChannel('blackhole_vpn');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
