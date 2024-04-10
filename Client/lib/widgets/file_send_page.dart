import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sync_magnet/src/services/client.dart';

class FileSendPage extends StatefulWidget {
  final SyncSocketClient client;
  final List<File> files;
  const FileSendPage({required this.client, required this.files, super.key});

  @override
  State<FileSendPage> createState() => _FileSendPageState();
}

class _FileSendPageState extends State<FileSendPage> {
  late final Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: widget.client.isSendFile
          ? Center(
              child: Text(
                "Uploading",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ).tr(),
            )
          : Text(
              "Send File(s)",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ).tr(),
      content: widget.client.isSendFile
          ? const Stack(
              alignment: Alignment.center,
              children: [CircularProgressIndicator()],
            )
          : Text(
              "{} File will be send",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ).tr(args: [widget.files.length.toString()]),
      actions: widget.client.isSendFile
          ? null
          : [
              ElevatedButton(
                style: drawerButtonStyle(),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ).tr(),
              ),
              ElevatedButton(
                style: drawerButtonStyle(),
                onPressed: () async {
                  if (widget.files.length > 1) {
                    await widget.client.sendMultipleFile(files: widget.files);
                  } else {
                    await widget.client.sendSelectFile(file_: widget.files[0]);
                  }
                  _setTimer();
                  setState(() {});
                },
                child: Text(
                  "Send",
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ).tr(),
              )
            ],
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
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _setTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (widget.client.isSendFileCompleted) {
        widget.client.isSendFileCompleted = false;
        setState(() {});
        t.cancel();
        Navigator.of(context).pop();
      }
    });
  }
}
