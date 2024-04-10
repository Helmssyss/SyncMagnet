import 'dart:async';
import 'dart:io';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sync_magnet/src/services/client.dart';

class FileAcceptPage extends StatefulWidget {
  final SyncSocketClient client;
  const FileAcceptPage({
    required this.client,
    super.key,
  });

  @override
  State<FileAcceptPage> createState() => _FileAcceptPageState();
}

class _FileAcceptPageState extends State<FileAcceptPage> {
  bool _isLoading = false;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    _setTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    if (widget.client.loadedFiles.isNotEmpty) widget.client.loadedFiles.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Get This File from PC",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ).tr(),
      elevation: 3,
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: widget.client.forPageIsLoadScreen
          ? SizedBox(
              height: 110,
              width: 30,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : SizedBox(
              height: 160,
              width: 30,
              child: ListView.builder(
                itemCount: widget.client.loadedFiles.length,
                itemBuilder: (context, index) => ListTile(
                  leading: getFolderIcon(
                      widget.client.loadedFiles[index]['file_name']),
                  title: Text(
                    widget.client.loadedFiles[index]['file_name'],
                    style: GoogleFonts.aBeeZee(
                      fontSize: 13,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    formatSize(widget.client.loadedFiles[index]['file_size']),
                    style: GoogleFonts.aBeeZee(
                      fontSize: 14,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      actions: widget.client.forPageIsLoadScreen
          ? null
          : [
              ElevatedButton(
                style: drawerLoginButtonStyle(context),
                onPressed: () => _createSyncMagnetFolderAndSaveFile(),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Text(
                        "Done",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ).tr(),
              ),
            ],
    );
  }

  void _setTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!widget.client.forPageIsLoadScreen) {
        setState(() {});

        timer.cancel();
      }
      if (widget.client.clientIsDisconnect) {
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.of(context).pop(),
        );
      }
      if (widget.client.isClose) {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  void _createSyncMagnetFolderAndSaveFile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.client.declineFile();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
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

  bool isDirectory(String path) {
    try {
      final file = Directory(path);
      return file.existsSync();
    } catch (e) {
      return false;
    }
  }

  Widget getFolderIcon(String basename) {
    if (isDirectory(basename)) {
      return const SizedBox();
    } else {
      const List<String> fileExtention = [".jpg", ".png", ".jpeg"];
      String baseName = basename.toLowerCase();
      for (var extention in fileExtention) {
        if (baseName.endsWith(extention)) {
          return fileIMAGEicon();
        }
      }
      if (basename.endsWith(".mp4")) {
        return fileMP4icon();
      } else if (basename.endsWith(".pdf")) {
        return filePDFicon();
      } else if (basename.endsWith(".gif")) {
        return fileGIFicon();
      } else if (basename.endsWith(".wav") || basename.endsWith(".mp3")) {
        return fileVIDEOicon();
      } else if (basename.endsWith(".apk")) {
        return fileAPKicon();
      } else if (basename.endsWith(".exe")) {
        return fileEXEicon();
      } else if (basename.endsWith('.zip')) {
        return fileArchiveicon();
      } else {
        return fileTEXTicon();
      }
    }
  }

  Stack fileArchiveicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Icon(Icons.folder_zip_rounded,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
              shadows: [
                Shadow(
                  color: Theme.of(context).colorScheme.primary,
                  blurRadius: 12,
                )
              ]),
        ),
      ],
    );
  }

  Stack fileIMAGEicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1, right: 4.0),
          child: Icon(
            Icons.image_rounded,
            size: 50,
            color: Theme.of(context).primaryIconTheme.color,
            shadows: [
              Shadow(
                color: Theme.of(context).colorScheme.primary,
                blurRadius: 12,
              )
            ],
          ),
        ),
      ],
    );
  }

  Stack fileLOCKicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Icon(Icons.lock_rounded,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
              shadows: [
                Shadow(
                  color: Theme.of(context).colorScheme.primary,
                  blurRadius: 12,
                )
              ]),
        ),
      ],
    );
  }

  Stack fileEXEicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryIconTheme.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  blurRadius: 12,
                )
              ],
            ),
            child: Center(
              child: Text(
                ".EXE",
                style: GoogleFonts.lilitaOne(
                  fontSize: 20,
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack fileAPKicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Icon(
                Icons.android_rounded,
                color: Theme.of(context).primaryIconTheme.color,
                size: 20,
                shadows: [
                  Shadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 12,
                  )
                ],
              ),
              Positioned(
                bottom: 22,
                left: 14, // İstenilen yükseklik değerini ayarlayın
                child: Text(
                  ".APK",
                  style: GoogleFonts.lilitaOne(
                    fontSize: 10,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack fileTEXTicon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.text_snippet_sharp,
            size: 50,
            color: Theme.of(context).primaryIconTheme.color,
            shadows: [
              Shadow(
                color: Theme.of(context).colorScheme.primary,
                blurRadius: 12,
              )
            ],
          ),
        ),
      ],
    );
  }

  Stack fileVIDEOicon() {
    return Stack(
      children: [
        Icon(
          Icons.audio_file_rounded,
          size: 50,
          color: Theme.of(context).primaryIconTheme.color,
          shadows: [
            Shadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 12,
            )
          ],
        ),
      ],
    );
  }

  Stack fileGIFicon() {
    return Stack(
      children: [
        Icon(
          Icons.gif_box_rounded,
          size: 50,
          color: Theme.of(context).primaryIconTheme.color,
          shadows: [
            Shadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 12,
            )
          ],
        ),
      ],
    );
  }

  Stack filePDFicon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryIconTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    "PDF",
                    style: GoogleFonts.lilitaOne(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack fileMP4icon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.movie_creation_rounded,
          size: 50,
          color: Theme.of(context).primaryIconTheme.color,
          shadows: [
            Shadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 12,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 6),
          child: Icon(
            Icons.play_arrow_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ],
    );
  }

  String formatSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      double kbSize = size / 1024;
      return '${kbSize.toStringAsFixed(2)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      double mbSize = size / (1024 * 1024);
      return '${mbSize.toStringAsFixed(2)} MB';
    } else {
      double gbSize = size / (1024 * 1024 * 1024);
      return '${gbSize.toStringAsFixed(2)} GB';
    }
  }
}
