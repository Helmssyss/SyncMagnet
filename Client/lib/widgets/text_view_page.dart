import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFileViewPage extends StatefulWidget {
  const TextFileViewPage({super.key});

  @override
  State<TextFileViewPage> createState() => _TextFileViewPageState();
}

class _TextFileViewPageState extends State<TextFileViewPage> {
  final TextEditingController noteController = TextEditingController();
  late final Map<String, dynamic> getArgs =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late final String fileName = getArgs["entities"]
      .path
      .split('/')[getArgs["entities"].path.split('/').length - 1];
  bool textIsChanged = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readFile(getArgs["entities"] as File),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          noteController.text = snapshot.data!;

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text(
                fileName,
                style: GoogleFonts.lilitaOne(
                  fontSize: 25,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async => await writeFile(
                    getArgs["entities"] as File,
                    noteController.text,
                  ).then(
                    (value) => showDialog(
                      context: context,
                      builder: (context) => savedFileScreen(context),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Theme.of(context).colorScheme.background,
                  )),
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: textFieldDecoration(),
                  textInputAction: TextInputAction.newline,
                  onChanged: (String value) => textFieldOnChanged(),
                  cursorColor: Colors.blue,
                  cursorWidth: 3,
                  cursorHeight: 20,
                  cursorRadius: const Radius.circular(10),
                  controller: noteController,
                  maxLines: noteController.text.length,
                )),
            floatingActionButton:
                getArgs['client'].isTransfer && getArgs['client'].isConnected
                    ? FloatingActionButton(
                        onPressed: () {
                          getArgs["client"].sendSelectFile(
                            image: getArgs["entities"] as File,
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.file_upload_outlined,
                          size: 35,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      )
                    : null,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<String> readFile(File file) async {
    return await file.readAsString();
  }

  Future<void> writeFile(File file, String content) async {
    await file.writeAsString(content);
  }

  Widget savedFileScreen(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Navigator.of(context).pop();
      timer.cancel();
    });
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Text(
        "Saved!",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return const InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
    );
  }

  void textFieldOnChanged() {
    textIsChanged = true;
  }
}
