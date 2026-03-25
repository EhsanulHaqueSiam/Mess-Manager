package com.area51.area51

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val pluginClasses = listOf(
            "io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin",
            "io.material.plugins.dynamic_color.DynamicColorPlugin",
            "com.mr.flutter.plugin.filepicker.FilePickerPlugin",
            "io.flutter.plugins.firebase.analytics.FlutterFirebaseAnalyticsPlugin",
            "io.flutter.plugins.firebase.appcheck.FlutterFirebaseAppCheckPlugin",
            "io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin",
            "io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin",
            "io.flutter.plugins.firebase.crashlytics.FlutterFirebaseCrashlyticsPlugin",
            "io.flutter.plugins.firebase.inappmessaging.FirebaseInAppMessagingPlugin",
            "io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin",
            "io.flutter.plugins.firebase.performance.FlutterFirebasePerformancePlugin",
            "io.flutter.plugins.firebase.firebaseremoteconfig.FirebaseRemoteConfigPlugin",
            "dev.polymorph.flutter_advanced_haptic.FlutterHapticPlugin",
            "com.ajinasokan.flutterdisplaymode.DisplayModePlugin",
            "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin",
            "net.jonhanson.flutter_native_splash.FlutterNativeSplashPlugin",
            "io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin",
            "com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin",
            "com.baseflow.geocoding.GeocodingPlugin",
            "com.baseflow.geolocator.GeolocatorPlugin",
            "com.google_mlkit_commons.GoogleMlKitCommonsPlugin",
            "com.google_mlkit_text_recognition.GoogleMlKitTextRecognitionPlugin",
            "io.flutter.plugins.googlesignin.GoogleSignInPlugin",
            "es.antonborri.home_widget.HomeWidgetPlugin",
            "io.flutter.plugins.imagepicker.ImagePickerPlugin",
            "dev.flutter.plugins.integration_test.IntegrationTestPlugin",

            "io.flutter.plugins.localauth.LocalAuthPlugin",
            "dev.steenbakker.mobile_scanner.MobileScannerPlugin",
            "dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin",
            "io.flutter.plugins.pathprovider.PathProviderPlugin",
            "com.baseflow.permissionhandler.PermissionHandlerPlugin",
            "net.nfet.flutter.printing.PrintingPlugin",
            "io.flutter.plugins.quickactions.QuickActionsPlugin",
            "dev.fluttercommunity.plus.share.SharePlusPlugin",
            "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin",
            "com.csdcorp.speech_to_text.SpeechToTextPlugin",
            "com.tekartik.sqflite.SqflitePlugin",
            "dev.fluttercommunity.workmanager.WorkmanagerPlugin",
        )

        for (className in pluginClasses) {
            try {
                val pluginClass = Class.forName(className)
                val plugin = pluginClass.getDeclaredConstructor().newInstance()
                if (plugin is io.flutter.embedding.engine.plugins.FlutterPlugin) {
                    flutterEngine.plugins.add(plugin)
                }
            } catch (e: Exception) {
                Log.w(TAG, "Plugin $className not available: ${e.message}")
            }
        }
    }

    companion object {
        private const val TAG = "PluginRegistrant"
    }
}
