import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_magnet/src/functions/theme_data.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:sync_magnet/widgets/setting_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool isSwitch = false;
  late final GoogleADS _googleADS;

  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _googleADS.interstitialAdLoad();
    _loadThemeData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => const SettingsPage(),
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.settings,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      title: Text(
                        "Settings",
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ).tr(),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .popAndPushNamed("/changelog", arguments: _googleADS),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.campaign_rounded,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      title: Text(
                        "Changelog",
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ).tr(),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          getCurrentThemeModeIcon(),
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    title: Text(
                      isSwitch ? "Dark Mode" : "Light Mode",
                      style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.w900,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ).tr(),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor:
                          Theme.of(context).primaryIconTheme.color,
                      value: isSwitch,
                      onChanged: (value) async {
                        if (!isSwitch) {
                          await SYNCThemeData.saveDarkTheme(true);
                          SYNCThemeData.getThemeNotifier!.value =
                              ThemeMode.dark;
                        } else {
                          await SYNCThemeData.saveDarkTheme(false);
                          SYNCThemeData.getThemeNotifier!.value =
                              ThemeMode.light;
                        }
                        setState(() {
                          SYNCThemeData.getDarkThemeState().then((value) {
                            isSwitch = value!;
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              indent: 20,
              endIndent: 20,
            ),
            TextButton(
              child: Text(
                "Get Windows Desktop Application",
                style: GoogleFonts.comfortaa(
                  fontWeight: FontWeight.w900,
                  textStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ).tr(),
              onPressed: () async {
                Random random = Random();
                final int rndNum = random.nextInt(6);
                if (rndNum == 2) {
                  _googleADS.interstitialAd!.show();
                }
                await launchUrl(
                  Uri.parse("https://github.com/Helmssyss/SyncMagnet"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadThemeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSwitch = preferences.getBool('isDarkTheme')!;
    });
  }

  IconData getCurrentThemeModeIcon() {
    switch (isSwitch) {
      case true:
        return Icons.dark_mode_rounded;
      default:
        return Icons.light_mode_rounded;
    }
  }
}
