import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kororyde_user/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../di/locator.dart' as locator;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/pushnotification/push_notification.dart';
import '../core/utils/connectivity_check.dart';
// import 'common.dart';
// import 'package:how_bodi_mobile/firebase_options.dart';


Future<void> commonSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51IuYWUSBCHfacuRqacrdy8IOlL3uUPq1XI0BZaRlqDPPcNsmywe6rSqjpM9HhVmELhXWhx95CH1pvNyQ8pvQEil900eGE0jXN8';
  Stripe.merchantIdentifier =
      'merchant.com.example'; // Replace with your Apple Pay merchant identifier (if applicable)
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  ConnectivityService().initialize();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
      // options: FirebaseOptions(
      //     apiKey: AppConstants.firbaseApiKey,
      //     appId: AppConstants.firebaseAppId,
      //     messagingSenderId: AppConstants.firebasemessagingSenderId,
      //     projectId: AppConstants.firebaseProjectId
          
      //     )
          );
  await locator.init();

  PushNotification().initMessaging();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Bloc.observer = const SimpleBlocObserver();
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// await FirebaseMessaging.instance.requestPermission();
  if (message.data['push_type'].toString() == 'meta-request') {
  } else {}
// const platforms = MethodChannel('flutter.app/awake');
//      platforms.invokeMethod('awakeapp');

//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
}

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
   // debugPrint('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(
        'onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- bloc: ${bloc.runtimeType}');
  }
}
