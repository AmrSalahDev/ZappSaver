import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class IntentUtils {
  static void openNotificationAccessSettings() {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }
}
