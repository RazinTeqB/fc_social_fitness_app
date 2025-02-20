package it.codeloops.fcsocialfitness

import android.os.Bundle
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
//import com.stripe.android.PaymentConfiguration;

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.tuo_pacchetto/overlay"
    private var overlayView: FrameLayout? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        /*PaymentConfiguration.init(
                applicationContext,
                "pk_test_51PvIx6L2fNeLVLZyy76eALEOci7m7jW4qzkP95WTBD0kCE0mEVctfm2Yn1bzlkErzzZb4tQ96WAVJu9wkrI025JO00lnDa192r"  // Sostituisci con la tua chiave pubblicabile di Stripe
        )*/

        // Blocca screenshot e registrazioni dello schermo
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "showOverlay" -> {
                    val message = call.argument<String>("message") ?: "Impossibile eseguire screenshot o registrazioni schermo"
                    showOverlay(message)
                    result.success(null)
                }
                "hideOverlay" -> {
                    hideOverlay()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showOverlay(message: String) {
        if (overlayView == null) {
            overlayView = FrameLayout(this).apply {
                setBackgroundColor(0xFF000000.toInt()) // Colore nero
                addView(TextView(this@MainActivity).apply {
                    text = message
                    setTextColor(0xFFFFFFFF.toInt()) // Colore bianco
                    textSize = 18f
                    gravity = android.view.Gravity.CENTER
                })
            }
            addContentView(overlayView, FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT
            ))
        } else {
            overlayView?.visibility = FrameLayout.VISIBLE
        }
    }

    private fun hideOverlay() {
        overlayView?.visibility = FrameLayout.GONE
    }
}