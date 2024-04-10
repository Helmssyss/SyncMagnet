import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class FileDeletePage extends StatefulWidget {
  List<FileSystemEntity> deleteFiles;
  List<bool> checkedBoxesList;
  FileDeletePage(
      {required this.deleteFiles, required this.checkedBoxesList, super.key});

  @override
  State<FileDeletePage> createState() => _FileDeletePageState();
}

class _FileDeletePageState extends State<FileDeletePage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Delete File(s)",
        style: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.bold,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).tr(),
      content: Text(
        "{} file will be deleted",
        style: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.bold,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ).tr(args: [
        widget.checkedBoxesList
            .where((element) => element == true)
            .length
            .toString()
      ]),
      actions: [
        ElevatedButton(
          style: drawerButtonStyle(),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "No",
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
          onPressed: () {
            print(widget.deleteFiles);
            for (var entity in widget.deleteFiles) {
              if (entity.existsSync()) {
                entity.deleteSync(recursive: true);
              }
            }

            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          child: Text(
            "Yes",
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
  }
}
