package com.alper.blackhole_vpn

import android.app.Activity
import android.content.ComponentName
import android.content.Context.BIND_AUTO_CREATE
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.IBinder
import androidx.core.app.ActivityCompat.startActivityForResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** BlackHoleVpnPlugin */
class BlackHoleVpnPlugin: FlutterPlugin, MethodCallHandler,ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel;
  private var eventSink : EventSink? = null
  private lateinit var result: Result
  private lateinit var allowedApps: List<String>
  private lateinit var binding: ActivityPluginBinding
  private var vpnService: MyVpnService? = null
  private var activity: Activity? = null

  private val vpnStartCode = 346093690

  private val vpnServiceIntent get() = if (activity==null) null else Intent(activity!!, MyVpnService::class.java)

  private val serviceConnection = object : ServiceConnection{
    override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
      val binder = service as MyVpnService.LocalBinder
      vpnService = binder.getService()
      vpnService!!.statusCallback = ::vpnStatusChange
    }

    override fun onServiceDisconnected(name: ComponentName?) {
      vpnService = null
    }
  }
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blackhole_vpn")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"blackhole_vpn_status_change")
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
          onActivityResult(vpnStartCode,Activity.RESULT_OK,null)
        } else {
          startActivityForResult(activity!!,permissionIntent,vpnStartCode,null)
        }
      }
      }
      "stopVpn" -> {
        if (activity==null) {
          result.error("notAttachedActivity",null,null)
        }
        else {
          MyVpnService.stopper?.invoke()
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
    eventChannel.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    activity!!.bindService(vpnServiceIntent!!,serviceConnection,BIND_AUTO_CREATE)
    binding.addActivityResultListener(this)
    eventChannel.setStreamHandler(object : StreamHandler{
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink=events;
      }

      override fun onCancel(arguments: Any?) {
        eventSink=null;
      }
    })
    this.binding = binding
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity!!.unbindService(serviceConnection)
    activity=null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity=binding.activity
    activity!!.bindService(vpnServiceIntent,serviceConnection,BIND_AUTO_CREATE)
  }

  override fun onDetachedFromActivity() {
    activity!!.unbindService(serviceConnection)
    activity=null
    binding.removeActivityResultListener(this)
  }
  private fun vpnStatusChange(isActive: Boolean): Unit {
    eventSink?.success(isActive);
  }
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    return if (requestCode==vpnStartCode) {
      if (resultCode == Activity.RESULT_OK) {

        vpnServiceIntent!!.putExtra("allowedApps",ArrayList(allowedApps))

        try {
          activity!!.startService(vpnServiceIntent)
          result.success(true)
        }
        catch (e: PackageManager.NameNotFoundException) {
          activity!!.unbindService(serviceConnection)
          result.error("packageNotFound","Package not found", null)
        }

      }
      else result.success(false)
      true
    } else {
      false
    }
  }}



