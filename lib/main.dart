import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth.dart';
import 'providers/ride_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/maps_provider.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/car_info_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: MapsProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, DriverProvider>(
          create: (_) => DriverProvider(),
          update: (_, auth, driverData) => driverData!..update(auth),
        ),
        ChangeNotifierProxyProvider2<Auth, DriverProvider, RideProvider>(
          create: (_) => RideProvider(),
          update: (_, auth, driverData, rideData) =>
              rideData!..update(auth, driverData),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Boomer Driver App',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: routes,
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> get routes {
    return {
      SplashScreen.routeName: (ctx) => SplashScreen(),
      AuthScreen.routeName: (ctx) => AuthScreen(),
      HomeScreen.routeName: (ctx) => HomeScreen(),
      CarInfoScreen.routeName: (ctx) => CarInfoScreen(),
    };
  }
}

final themeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xff423833),
  primaryColorLight: Color(0xffA28F86),
  primaryColorDark: Color(0xff342C28),
  accentColor: Color(0xffD1793F),
  fontFamily: 'Open Sans',
  focusColor: Color(0xffD1793F),
  scaffoldBackgroundColor: Color(0xff423833),
  canvasColor: Color(0xff342C28),
  // canvasColor: Color(0xffB8AAA3),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 14,
      color: Color(0xff8A756B),
      fontWeight: FontWeight.w700,
    ),
    headline2: TextStyle(
      fontSize: 14,
      color: Color(0xff6D5D54),
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      color: Color(0xffB8AAA3),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headline4: TextStyle(
      fontSize: 20,
      color: Color(0xffD1793F),
      fontWeight: FontWeight.w700,
    ),
    headline5: TextStyle(
      fontSize: 20,
      color: Color(0xffFBFAF9),
      fontWeight: FontWeight.w700,
    ),
    headline6: TextStyle(
      color: Color(0xffA28F86),
      fontSize: 20,
    ),
    bodyText2: TextStyle(
      color: Color(0xffB8AAA3),
      fontSize: 14,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xff423833),
    iconTheme: IconThemeData(
      color: Color(0xffD1793F),
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xffA28F86),
        fontSize: 20,
      ),
    ),
  ),
);
