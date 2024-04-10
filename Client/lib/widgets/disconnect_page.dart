// import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sync_magnet/src/services/client.dart';
import 'package:sync_magnet/src/services/google_ads.dart';

// ignore: must_be_immutable
class DisconnectPage extends StatefulWidget {
  late SyncSocketClient client;
  DisconnectPage({required this.client, super.key});

  @override
  State<DisconnectPage> createState() => _DisconnectPageState();
}

class _DisconnectPageState extends State<DisconnectPage> {
  bool isQuit = false;
  late final GoogleADS _googleADS;
  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _googleADS.interstitialAdLoad();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: !isQuit
          ? Text("Do you want to disconnect?",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ))
          : Stack(alignment: Alignment.center, children: [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 65),
                child: Text(
                  "Disconnecting",
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              )
            ]),
      actions: !isQuit
          ? [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: drawerButtonStyle(),
                child: Text("No",
                    style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.bold,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    )),
              ),
              ElevatedButton(
                  onPressed: () {
                    // _googleADS.interstitialAd!.show();
                    isQuit = true;
                    // setState(() {});
                    widget.client.closeConnectToDevice();
                    Navigator.of(context).pop();
                  },
                  style: drawerButtonStyle(),
                  child: Text("Yes",
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      )))
            ]
          : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 0.8,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  ButtonStyle drawerButtonStyle() {
    return ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.background),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
  }
}

class CallDisconnectLoadScreen extends StatelessWidget {
  const CallDisconnectLoadScreen({super.key});

  final Color darkColor = const Color.fromARGB(255, 18, 18, 18);
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 2), () => Navigator.of(context).pop());

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Stack(alignment: Alignment.center, children: [
        const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 65),
          child: Text(
            "Disconnecting",
            style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ).tr(),
        )
      ]),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 0.8,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}
