package com.blackcode.zappsaver

import android.content.Context
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "notification_listener_permission"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isNotificationPermissionGranted" -> {
                    val isGranted = isNotificationServiceEnabled()
                    result.success(isGranted)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val contentResolver = applicationContext.contentResolver
        val enabledListeners =
            Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        return enabledListeners?.contains(packageName) == true
    }
}
