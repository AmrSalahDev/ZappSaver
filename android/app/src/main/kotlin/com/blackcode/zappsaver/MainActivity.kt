package com.blackcode.zappsaver

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.net.Uri
import android.provider.Settings
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val NOTIF_CHANNEL = "notification_listener_permission"
    private val APK_SHARE_CHANNEL = "apk_share_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Channel for notification listener permission
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIF_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isNotificationPermissionGranted" -> {
                        val isGranted = isNotificationServiceEnabled()
                        result.success(isGranted)
                    }
                    else -> result.notImplemented()
                }
            }

        // Channel for APK sharing
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APK_SHARE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "shareApk") {
                    shareApk()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val contentResolver = applicationContext.contentResolver
        val enabledListeners =
            Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        return enabledListeners?.contains(packageName) == true
    }

    private fun shareApk() {
        try {
            val app: ApplicationInfo = applicationContext.applicationInfo
            val apkPath = app.sourceDir
            val apkFile = File(apkPath)

            val apkUri: Uri = FileProvider.getUriForFile(
                applicationContext,
                "${applicationContext.packageName}.provider",
                apkFile
            )

            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "application/vnd.android.package-archive"
                putExtra(Intent.EXTRA_STREAM, apkUri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            startActivity(Intent.createChooser(intent, "Share App APK"))
        } catch (e: Exception) {
            Toast.makeText(applicationContext, "Error sharing APK", Toast.LENGTH_SHORT).show()
        }
    }
}
