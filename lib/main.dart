import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/verification_screen.dart';
import 'package:uridachi/app/splash_screen.dart';
import 'package:uridachi/utils/utils.dart';
import 'package:uridachi/widgets/global_sns_widgets/time_ago.dart';
import 'core/di/app_dependency_injection.dart';
import 'core/di/block_report_depencencies.dart';
import 'features/auth/presentation/providers/app_auth_provider.dart';
import 'features/block_report/presentation/providers/block_report_provider.dart';
import 'features/post/presentation/providers/post_provider.dart';
import 'features/user/presentation/providers/user_data_holder.dart';
import 'features/user/presentation/providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  print("Handling a background message: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  timeago.setLocaleMessages('en_custom', TimeMessages());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showSnackBar(navigatorKey.currentContext!, message.notification?.body);
    }
  });

  // Dependency Injection
  initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AppAuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PostProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<BlockReportProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<UserDataHolder>()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        showSemanticsDebugger: false,
        home: SplashScreen(),
        navigatorObservers: [
          routeObserver
        ],
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
          Locale('ja', ''),
        ],
        locale: _locale,
        localeResolutionCallback: (locale, supportedLocales) {
          if (_locale != null) {
            return _locale;
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
