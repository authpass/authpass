package design.codeux.authpass;

import android.os.Bundle;
import android.provider.Settings;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "app.authpass/misc";
    private static final String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public SplashScreen provideSplashScreen() {
        return null;
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if ("isFirebaseTestLab".equals(call.method)) {
                result.success("true".equals(Settings.System.getString(getContentResolver(), "firebase.test.lab")));
                return;
            }
            result.notImplemented();
        });
    }

//    no longer required, handled by FilePickerWritable plugin.
//    @NonNull
//    @Override
//    protected String getInitialRoute() {
//        Uri data = getIntent().getData();
//        if (data != null) {
//            String filePath = FileUtils.getPath(data, this);
//            if (filePath == null) {
//                filePath = FileUtils.getUriFromRemote(this, data);
//            }
//            String initialRoute = "/openFile?file=" + Uri.encode(filePath);
//            Log.i(TAG, "Got intent data: " + data + ", initialRoute: " + initialRoute);
//            return initialRoute;
//        }
//        return super.getInitialRoute();
//    }
}
