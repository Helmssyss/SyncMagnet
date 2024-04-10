import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sync_magnet/src/functions/page_routers.dart';
import 'package:sync_magnet/src/functions/theme_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await MobileAds.instance.initialize();
  await SYNCThemeData.darkThemeState();
  await Permission.notification.isDenied.then((val) {
    if (val) {
      Permission.notification.request();
    }
  });
  await SYNCThemeData.selectDarkTheme();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'), // default
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      child: const SyncMagnet(),
    ),
  );
}

class SyncMagnet extends StatelessWidget {
  const SyncMagnet({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SYNCThemeData.getThemeNotifier!,
      builder: (BuildContext context, ThemeMode currentMode, Widget? widget) {
        return MaterialApp(
          onGenerateRoute: (settings) =>
              PageRouters.goRouters(settings: settings),
          darkTheme: SYNCThemeData.getDarkTheme,
          theme: SYNCThemeData.getLightTheme,
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
