import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iris_nest_app/themes/app_theme.dart';
import 'package:iris_nest_app/themes/design_course_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introduction_animation/introduction_animation_screen.dart';
import 'navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity/connectivity.dart';
const d_red = Color(0xFFE9717D);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print('mobile');
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print('wifi');
  } else if (connectivityResult == ConnectivityResult.none) {
    // pop up dialog to refresh the page
    print('none');
  }
  FirebaseMessaging.instance.getToken().then((value) => print('token is $value'));
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
  });
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => print('token is $value'));
    //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // listen to notification on opened app
   /* _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );*/
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // launch notification on opened app
        Get.snackbar(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: DesignCourseAppTheme.IrisThirdBlue,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            borderRadius: 20,
            dismissDirection: DismissDirection.horizontal,
            mainButton: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            shouldIconPulse: true,
            duration: const Duration(seconds: 10),
            onTap: (snack) {
              //Get.to(() => NavigationHomeScreen());
              Get.back();
            },
            icon: const Icon(Icons.notifications, color: Colors.white,)
        );
        // make sound on notification received
        /*var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification'),
        );
        var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          platformChannelSpecifics,
          payload: 'Default_Sound',
        );*/
      }
    });
    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
      Get.to(() => NavigationHomeScreen());
    });*/
  }

  bool isRemembered = false;
  bool isEagleLoggedIn = false;
  String? myToken = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot)
        {
          if(!snapshot.hasData){
            return const GetMaterialApp(home: Scaffold(body: Center(child: Text('Loading...'),),),);
          }else{
            isRemembered = snapshot.data?.getBool('Remember me') ?? false;
            isEagleLoggedIn = snapshot.data?.getBool('EagleLoggedIn') ?? false;
            if (isRemembered == true && isEagleLoggedIn == true) {
              return GetMaterialApp(
                title: 'Flutter UI',
                debugShowMaterialGrid: false,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: AppTheme.textTheme,
                  platform: TargetPlatform.iOS,
                ),
                home: NavigationHomeScreen(),
              );
            }
            else if (isRemembered == false && isEagleLoggedIn == true) {
              return GetMaterialApp(
                title: 'Flutter UI',
                debugShowMaterialGrid: false,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: AppTheme.textTheme,
                  platform: TargetPlatform.iOS,
                ),
                //home: NavigationHomeScreen(),
                home: const IntroductionAnimationScreen(),
              );
            }
            else if (isRemembered == false && isEagleLoggedIn == false) {
              return GetMaterialApp(
                title: 'Flutter UI',
                debugShowMaterialGrid: false,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: AppTheme.textTheme,
                  platform: TargetPlatform.iOS,
                ),
                //home: NavigationHomeScreen(),
                home: const IntroductionAnimationScreen(),
              );
            }
            else {
              return GetMaterialApp(
                title: 'Flutter UI',
                debugShowMaterialGrid: false,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: AppTheme.textTheme,
                  platform: TargetPlatform.iOS,
                ),
                //home: NavigationHomeScreen(),
                home: const IntroductionAnimationScreen(),
              );
            }
          }
        }
    ) ;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}