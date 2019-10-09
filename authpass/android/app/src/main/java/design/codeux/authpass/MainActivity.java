package design.codeux.authpass;

import android.os.Bundle;
import android.provider.Settings;

import androidx.annotation.NonNull;
import io.flutter.app.FlutterActivity;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
  private static final String CHANNEL = "app.authpass/misc";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if ("isFirebaseTestLab".equals(call.method)) {
          result.success("true".equals(Settings.System.getString(getContentResolver(), "firebase.test.lab")));
          return;
        }
        result.notImplemented();
      }
    });
  }
}
