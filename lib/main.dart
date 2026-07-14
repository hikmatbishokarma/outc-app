import 'package:flutter/material.dart';
import 'package:outc/Splash/splashpage.dart';
import 'package:outc/dashboard/flights/providers/oneway_provider.dart';
import 'package:outc/partnerSidemenu/providers/carreportprovider.dart';
import 'package:outc/partnerSidemenu/providers/depositsprovider.dart';
import 'package:outc/partnerSidemenu/providers/flightreportsprovider.dart';
import 'package:outc/partnerSidemenu/providers/hotelreportsprovider.dart';
import 'package:outc/partnerSidemenu/providers/statementsprovider.dart';
import 'package:outc/partnerSidemenu/providers/visareportprovider.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:outc/widgets/themes/app_dark_theme_data.dart';
import 'package:outc/widgets/themes/app_light_theme_data.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefServices.init();
  runApp(MultiProvider(providers: providers, child: MyApp()));
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => ReportsProvider()),
  ChangeNotifierProvider(create: (_) => FlightReportsProvider()),
  ChangeNotifierProvider(create: (_) => VisaReportsProvider()),
  ChangeNotifierProvider(create: (_) => CarReportsProvider()),
  ChangeNotifierProvider(create: (_) => DepositReportsProvider()),
  ChangeNotifierProvider(create: (_) => StatementReportsProvider()),
  ChangeNotifierProvider(create: (_) => OnewayProvider()),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      builder: BotToastInit(),
      navigatorKey: NavigationService.navigatorKey,

      navigatorObservers: [BotToastNavigatorObserver()],
      routes: <String, WidgetBuilder>{
        '/': (context) => const Splashscreen(),
      },

      // MaterialColor primeColor = MaterialColor(0xFF337C36, color);

      theme: appLightThemeData(),
      darkTheme: appDarkThemeData(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // home: VideoPlayerScreen(),
      // home: MyApp(),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
