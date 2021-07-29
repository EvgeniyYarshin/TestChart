package com.example.temperature_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import kotlinx.coroutines.*
import kotlin.random.Random


/** TemperaturePlugin */
class TemperaturePlugin : FlutterPlugin, EventChannel.StreamHandler {

    private val intentTemperatureName = "TEMPERATURE_INTENT"
    private val intentTemperature = "TEMPERATURE"
    private lateinit var eventChannel: EventChannel
    private var applicationContext: Context? = null

    private var chargingStateChangeReceiver: BroadcastReceiver? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
    }


    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        this.applicationContext = applicationContext
        eventChannel = EventChannel(messenger, "temperature_plugin")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = null
        eventChannel.setStreamHandler(null)
    }

    lateinit var job: Job

    @InternalCoroutinesApi
    override fun onListen(arguments: Any?, events: EventSink?) {
        val intent = Intent(intentTemperatureName)
        var lastTemperature = 40
        chargingStateChangeReceiver = createTemperatureStateChangeReceiver(events!!)
        applicationContext?.registerReceiver(chargingStateChangeReceiver, IntentFilter(intentTemperatureName))
        job = CoroutineScope(Dispatchers.Default).launch {
            while (NonCancellable.isActive) {
                lastTemperature = Random.nextInt(lastTemperature - 5, lastTemperature + 5)
                if(lastTemperature < 0) {
                    lastTemperature = 0
                }
                else if(lastTemperature > 150) {
                    lastTemperature = 150
                }
                intent.putExtra(intentTemperature, lastTemperature)
                applicationContext?.sendBroadcast(intent)
                delay(1000)
            }
        }
    }

    private fun createTemperatureStateChangeReceiver(events: EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                events.success(intent.getIntExtra(intentTemperature, 0))
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        job.cancel()
    }
}



