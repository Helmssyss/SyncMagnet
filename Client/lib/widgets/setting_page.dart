import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_magnet/src/functions/theme_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool theme1 = false;
  bool theme2 = false;
  bool theme3 = false;

  @override
  void initState() {
    super.initState();
    readThemeState();
    print("theme1 = $theme1");
    print("theme2 = $theme2");
    print("theme3 = $theme3");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: Text("Select Dark Theme",
          style: GoogleFonts.comfortaa(
            fontWeight: FontWeight.w900,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          )).tr(),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: theme1,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (theme1) {
                          theme2 = false;
                          theme3 = false;
                        } else {
                          theme1 = true;
                          theme2 = false;
                          theme3 = false;
                        }
                        await setThemeState();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                stops: [0.46, 0.56],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.amber, Colors.black87])),
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: theme2,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 10,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (theme2) {
                          theme1 = false;
                          theme3 = false;
                        } else {
                          theme1 = false;
                          theme2 = true;
                          theme3 = false;
                        }
                        await setThemeState();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                stops: [0.46, 0.56],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.deepPurple, Colors.black87])),
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: theme3,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (theme3) {
                          theme1 = false;
                          theme2 = false;
                        } else {
                          theme1 = false;
                          theme2 = false;
                          theme3 = true;
                        }
                        await setThemeState();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            stops: [0.46, 0.56],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.indigo, Colors.black87],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> setThemeState() async {
    SYNCThemeData.getThemeNotifier!.value = ThemeMode.light;
    SYNCThemeData.getThemeNotifier!.value = ThemeMode.dark;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("theme1", theme1);
    preferences.setBool("theme2", theme2);
    preferences.setBool("theme3", theme3);
    await SYNCThemeData.selectDarkTheme();
    setState(() {});
  }

  Future<void> readThemeState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme1 = preferences.getBool("theme1") ?? false;
    theme2 = preferences.getBool("theme2") ?? false;
    theme3 = preferences.getBool("theme3") ?? false;
    setState(() {});
  }
}
