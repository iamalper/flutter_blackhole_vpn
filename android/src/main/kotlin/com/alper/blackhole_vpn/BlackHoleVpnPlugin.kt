package com.alper.blackhole_vpn

import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.VpnService
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat.startActivityForResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.ByteArrayOutputStream


/** BlackHoleVpnPlugin */
class BlackHoleVpnPlugin: FlutterPlugin, MethodCallHandler,ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var result: Result
  private lateinit var allowedApps: List<String>
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blackhole_vpn")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    this.result=result

    when (call.method) {
      "startVpn" -> {
        //Allowed apps for black hole VPN, they can't connect to internet.
        val allowedApps=call.argument<List<String>>("allowedApps")
        if (activity==null) {
          result.error("notAttachedActivity",null,null)
          }
        else if (allowedApps==null) {
          result.error("missingArgument",null,null)
        }
        else {
          this.allowedApps=allowedApps
        val permissionIntent = VpnService.prepare(activity)
        if (permissionIntent==null) {
          onActivityResult(1,Activity.RESULT_OK,null)
        } else {
          startActivityForResult(activity!!,permissionIntent,1,null)
        }
      }
      }
      "stopVpn" -> {
        if (activity==null) {
          result.error("notAttachedActivity",null,null)
        }
        else {
          MyVpnService.stopper?.invoke();
          result.success(null)
        }
      }
      "getStatus" -> {
        result.success(MyVpnService.alive)
      }
    else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity=null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity=binding.activity
  }

  override fun onDetachedFromActivity() {
   activity=null
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    return if (requestCode==1) {
      if (resultCode == Activity.RESULT_OK) {
        val vpnService = Intent(activity!!, MyVpnService::class.java)
        vpnService.putExtra("allowedApps",ArrayList(allowedApps))
        try {
          activity!!.startService(vpnService)
          result.success(true)
        }
        catch (e: PackageManager.NameNotFoundException) {
          result.error("packageNotFound","Package not found", null)
        }
      }
      else result.success(false)
      true
    } else {
      false
    }
  }
}
