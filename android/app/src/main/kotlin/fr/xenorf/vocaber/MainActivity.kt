package fr.xenorf.vocaber

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Enable edge-to-edge content rendering; Flutter UI should handle insets (SafeArea/MediaQuery)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
