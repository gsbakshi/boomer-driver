import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth.dart';
import 'providers/maps_provider.dart';
import 'providers/driver_provider.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/navigation_bar.dart';
import 'screens/profile_screen.dart';
import 'screens/ratings_screen.dart';
import 'screens/all_cars_screen.dart';
import 'screens/earnings_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, DriverProvider>(
          create: (_) => DriverProvider(),
          update: (_, auth, driverData) => driverData!..update(auth),
        ),
        ChangeNotifierProxyProvider<DriverProvider, MapsProvider>(
          create: (_) => MapsProvider(),
          update: (_, driver, mapsData) => mapsData!..update(driver),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => Consumer<DriverProvider>(
          builder: (ctx, driver, _) => MaterialApp(
            title: 'Boomer Driver App',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: auth.isAuth
                ? FutureBuilder(
                    future: driver.fetchDriverDetails(),
                    builder: (ctx, snapshot) => driver.cars.isNotEmpty
                        ? NavigationBar()
                        : CarInfoScreen(),
                  )
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
      ),
    );
  }

  Map<String, WidgetBuilder> get routes {
    return {
      SplashScreen.routeName: (ctx) => SplashScreen(),
      AuthScreen.routeName: (ctx) => AuthScreen(),
      CarInfoScreen.routeName: (ctx) => CarInfoScreen(),
      NavigationBar.routeName: (ctx) => NavigationBar(),
      HomeScreen.routeName: (ctx) => HomeScreen(),
      EarningsScreen.routeName: (ctx) => EarningsScreen(),
      RatingsScreen.routeName: (ctx) => RatingsScreen(),
      ProfileScreen.routeName: (ctx) => ProfileScreen(),
      AboutScreen.routeName: (ctx) => AboutScreen(),
      AllCarsScreen.routeName: (ctx) => AllCarsScreen(),
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
