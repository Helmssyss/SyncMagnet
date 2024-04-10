import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sync_magnet/src/services/client.dart';
import 'package:sync_magnet/src/services/google_ads.dart';

class ConnectPopupPage extends StatefulWidget {
  final SyncSocketClient client;
  const ConnectPopupPage({required this.client, super.key});

  @override
  State<ConnectPopupPage> createState() => _ConnectPopupPageState();
}

class _ConnectPopupPageState extends State<ConnectPopupPage> {
  final addrController = TextEditingController();
  late final GoogleADS _googleADS;
  bool buttonState = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _googleADS.interstitialAdLoad();
    addrController.addListener(
      () {
        if (addrController.text == "") {
          setState(() {
            buttonState = false;
          });
        } else {
          setState(() {
            buttonState = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 30,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      content: pageContent(context),
      actions: pageActions(context),
      title: Text(
        "Connect to Pc",
        style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).tr(),
    );
  }

  List<Widget>? pageActions(BuildContext context) {
    return !loading
        ? [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: connectMethod(context),
            )
          ]
        : null;
  }

  Widget pageContent(BuildContext context) {
    return loading
        ? Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryIconTheme.color,
                strokeWidth: 3,
              )
            ],
          )
        : TextField(
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w300,
              ),
            ),
            controller: addrController,
            decoration: textFieldDecoration(),
          );
  }

  ElevatedButton connectMethod(BuildContext context) {
    return ElevatedButton(
      style: buttonState
          ? drawerButtonStyle()
          : ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 45, 62, 92)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: const BorderSide(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
      onPressed: buttonState
          ? () async {
              if (await _requestPermission(Permission.storage)) {
                setState(() {
                  loading = true;
                });
                widget.client
                    .clientSetup(ip: addrController.text, port: 1881)
                    .then(
                  (val) {
                    if (val) {
                      widget.client.listenServer();
                      Timer.periodic(
                        const Duration(seconds: 1),
                        (timer) {
                          timer.cancel();
                          addrController.clear();
                          Navigator.of(context).pop();
                        },
                      );
                      _googleADS.interstitialAd!.show();
                    } else {
                      setState(() {
                        loading = false;
                      });
                      addrController.clear();
                      showDialog(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AlertDialog(
                            shape: BeveledRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            scrollable: false,
                            elevation: 2,
                            content: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Wrong",
                                  style: GoogleFonts.comfortaa(
                                    textStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      Timer.periodic(
                        const Duration(seconds: 1),
                        (timer) {
                          timer.cancel();
                          Navigator.of(context).pop();
                        },
                      );
                      print("HATA");
                    }
                  },
                );
              }
            }
          : null,
      child: Text(
        "Connect",
        style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
            color: !buttonState
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
        ),
      ).tr(),
    );
  }

  InputDecoration textFieldDecoration({fieldIsAddr = true}) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, width: 0.6),
      ),
      hintStyle: GoogleFonts.comfortaa(
        color: Theme.of(context).colorScheme.secondary,
      ),
      hintText: fieldIsAddr ? "IP" : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  ButtonStyle drawerButtonStyle() {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      backgroundColor: MaterialStateProperty.all<Color>(
        Theme.of(context).colorScheme.primary,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}
