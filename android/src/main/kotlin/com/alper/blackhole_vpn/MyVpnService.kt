package com.alper.blackhole_vpn

import android.content.Intent
import android.net.VpnService
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.channels.FileChannel


class MyVpnService : VpnService() {
    private var localTunnel:  ParcelFileDescriptor? = null
    private var byteLoop: Job? = null

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        stopper = {
            byteLoop?.cancel()
            localTunnel?.close()
            localTunnel=null
            alive = false
            stopSelf()
            stopper=null
        }
        val allowedApps = intent.getStringArrayListExtra("allowedApps") ?: ArrayList()
        val builder = Builder()
            .addAddress("10.1.1.1", 24).addRoute("0.0.0.0", 0)
        for (appPackage in allowedApps) {
            builder.addAllowedApplication(appPackage)
        }

        localTunnel = builder.establish()
        processBytes(
            FileInputStream(localTunnel!!.fileDescriptor).channel,
            FileOutputStream(localTunnel!!.fileDescriptor).channel
        )
        alive = true
        return START_NOT_STICKY

    }
    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    private fun processBytes(inputFileChannel: FileChannel, outputFileChannel: FileChannel) {
        byteLoop = CoroutineScope(Dispatchers.IO).launch{
                while (true) {
                    withContext(Dispatchers.IO) {
                        inputFileChannel.read(ByteBuffer.allocate(1024))
                    }
                    delay(100)
            }
        }
    }

    companion object {
        var alive = false
        var stopper: (() -> Unit)? = null
    }
}