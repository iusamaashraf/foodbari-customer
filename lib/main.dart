import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:get/get.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'router_name.dart';
import 'utils/k_strings.dart';
import 'utils/my_theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(
    fcm.RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  //BISMILLAH

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  fcm.FirebaseMessaging messaging = fcm.FirebaseMessaging.instance;
  fcm.NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  fcm.FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  fcm.FirebaseMessaging.onMessage.listen((fcm.RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    Get.snackbar("${message.notification!.title}", message.notification!.body!);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(
    const MyApp(),
  );
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   // controller.configOneSignel();
//   runApp(const MyApp());
// }

CustomerController controller = Get.put(CustomerController());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  //   OneSignal.shared.setAppId("73ec5ec6-22ef-4984-9ed5-7ed256034f36");
  //   super.initState();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Kstrings.appName,
      theme: MyTheme.theme,
      onGenerateRoute: RouteNames.generateRoute,
      initialRoute: RouteNames.animatedSplashScreen,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for $settings')),
          ),
        );
      },
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
    );
  }
}
