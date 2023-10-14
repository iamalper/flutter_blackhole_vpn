package com.alper.blackhole_vpn

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import org.testng.annotations.Test

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class PerAppVpnPluginTest {
  @Test
  fun onMethodCall_getVpnOn() {
    val plugin = PerAppVpnPlugin()
    val call = MethodCall("startVpn", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)
    Mockito.verify(mockResult).success(true)
  }
}
