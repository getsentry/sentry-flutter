package io.sentry.flutter.example

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "example.flutter.sentry.io"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // Note: this method is invoked on the main thread.
      if (call.method == "throw") {
        throw Exception("Thrown from Kotlin!")
      } else {
        result.notImplemented()
      }
    }
  }
}
