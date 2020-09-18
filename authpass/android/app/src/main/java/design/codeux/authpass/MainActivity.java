package design.codeux.authpass;

import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings;

import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "app.authpass/misc";
    private static final Logger logger = LoggerFactory.getLogger(MainActivity.class);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        logger.debug("onCreate " + intent);
        if (getIntent() != null) {
            logger.debug("onCreate Intent extras: " + getIntent().getExtras());
        }
    }

    @Override
    public SplashScreen provideSplashScreen() {
        return null;
    }

    @Override
    public void configureFlutterEngine(@NotNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
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
