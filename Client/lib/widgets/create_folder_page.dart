import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateFolderPage extends StatelessWidget {
  late final String path;
  CreateFolderPage({required this.path, super.key});
  final folderControllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Create Folder",
        style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 30,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.indigo, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: TextField(
        textAlign: TextAlign.center,
        style: GoogleFonts.aBeeZee(
          textStyle: const TextStyle(
            fontSize: 15,
            color: Colors.blue,
            fontWeight: FontWeight.w300,
          ),
        ),
        controller: folderControllerText,
        decoration: textFieldDecoration(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              if (folderControllerText.text.isNotEmpty) {
                if (await _requestPermission(Permission.storage)) {
                  // ignore: use_build_context_synchronously
                  await createFolder(context, folderControllerText.text);
                }
              }
            },
            child: Text("Create",
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.w900,
                  ),
                )),
          ),
        )
      ],
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 0.6),
      ),
      hintStyle: const TextStyle(
        color: Colors.blueAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Future<void> createFolder(BuildContext context, String folderName) async {
    Directory folder = Directory("$path/$folderName");

    if (!await folder.exists()) {
      await folder.create(recursive: true);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
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
