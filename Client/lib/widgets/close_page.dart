import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CloseAlertPage extends StatelessWidget {
  final StreamSubscription<void> mainStreamSubscription;

  const CloseAlertPage({required this.mainStreamSubscription, super.key});

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
      content: Text(
        "Do you want to exit",
        style: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.bold,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).tr(),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: drawerLoginButtonStyle(context),
          child: Text("No",
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              )).tr(),
        ),
        ElevatedButton(
          onPressed: () {
            final service = FlutterBackgroundService();
            service.invoke("stopService");
            mainStreamSubscription.cancel();
            SystemNavigator.pop();
          },
          style: drawerLoginButtonStyle(context),
          child: Text("Yes",
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              )).tr(),
        )
      ],
    );
  }

  ButtonStyle drawerLoginButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
