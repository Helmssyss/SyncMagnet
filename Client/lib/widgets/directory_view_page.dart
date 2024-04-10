import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:sync_magnet/src/functions/view_directory_icons.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:sync_magnet/widgets/create_folder_page.dart';
import 'package:sync_magnet/widgets/disconnect_page.dart';
import 'package:sync_magnet/widgets/drawer_page.dart';
import 'package:sync_magnet/widgets/file_accept_page.dart';
import 'package:sync_magnet/widgets/file_delete_page.dart';
import 'package:sync_magnet/widgets/file_send_page.dart';

class DirectoryViewPage extends StatefulWidget {
  const DirectoryViewPage({super.key});

  @override
  State<DirectoryViewPage> createState() => _DirectoryViewPageState();
}

class _DirectoryViewPageState extends State<DirectoryViewPage> {
  late final Map<String, dynamic> getArgs =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late Stream<void> backProcessLoop;
  late StreamSubscription<void> subscription;
  late final GoogleADS _googleADS;
  ChangeViewDirectory changeView = ChangeViewDirectory.Grid;
  Icon changeViewIcon = const Icon(Icons.grid_view_rounded);
  late Directory syncMagnetRootDirectory;
  String? currentPath;
  bool isAlertDialogOpen = false;
  bool isSelected = false;
  bool onNameSort = false;
  bool onLargestSizeSort = false;
  bool onSmallestSizeSort = false;
  bool onFolderNameSort = false;
  List<bool> selecteCheckBoxdItems = [];
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    syncMagnetRootDirectory = Directory("");
    _googleADS = GoogleADS();
    _googleADS.loadBannerAd(
      adLoaded: () {
        setState(() {});
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getSyncMagnetDirectory().then((Directory value) {
      if (getArgs.containsKey('path')) {
        syncMagnetRootDirectory = value;
        currentPath = value.path;
        files.removeWhere((FileSystemEntity element) =>
            path.basename(element.path) == 'Android');
      } else {
        syncMagnetRootDirectory = value;
        currentPath = value.path;
      }

      setState(() {
        selecteCheckBoxdItems = List.generate(files.length, (index) => false);
      });
    });
    backProcessLoop = Stream<void>.periodic(const Duration(milliseconds: 10));
    subscription = backProcessLoop.listen((event) {
      // print("EVENT -> backProcessLoop <-> ${getArgs['client'].clientIsDisconnect}");
      if (getArgs['client'].isTransfer && getArgs['client'].isConnected) {
        setState(() {});
      }
      if (getArgs['client'].clientIsDisconnect) {
        getArgs['client'].clientIsDisconnect = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const CallDisconnectLoadScreen();
          },
        ).then((_) {
          if (mounted) {
            setState(() {
              getArgs['client'].isConnected = false;
              getArgs['client'].isClose = true;
            });
          }
        });
      }
      if (getArgs['client'].isGetFile && !isAlertDialogOpen) {
        isAlertDialogOpen = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: FileAcceptPage(
                client: getArgs['client'],
              ),
            );
          },
        ).then((_) {
          isAlertDialogOpen = false;
          getArgs['client'].isGetFile = false;
          setState(() {});
        });
      }
      if (getArgs['client'].isGetFileCompleted) {
        setState(() {
          getArgs['client'].isGetFileCompleted = false;
          enterFolder(currentPath!);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentPath != null &&
            currentPath != syncMagnetRootDirectory.path) {
          String parentPath = path.dirname(currentPath!);
          setState(() {
            enterFolder(parentPath);
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.background,
          onRefresh: () async => setState(() {
            !isSelected ? enterFolder(currentPath!) : null;
          }),
          child: Stack(children: [
            if (files.isEmpty)
              Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                            shadows: [
                              Shadow(
                                color: Theme.of(context).colorScheme.primary,
                                blurRadius: 12,
                              )
                            ]),
                        Text(
                          "No Items",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ).tr(),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              )
            else
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: changeView == ChangeViewDirectory.Grid
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.80,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 30),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () async {
                                            if (!isSelected) {
                                              // print(
                                              //     "SA -> ${files[index].path}");
                                              if (FileManager.isFile(
                                                  files[index])) {
                                                // ignore: use_build_context_synchronously
                                                manageFileExtensions(
                                                    files[index]
                                                        .path
                                                        .toLowerCase(),
                                                    context,
                                                    index);
                                              } else {
                                                currentPath =
                                                    files[index].parent.path;
                                                enterFolder(files[index].path);
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              getFolderIcon(files[index].path),
                                              Text(
                                                setFileName(files, index),
                                                style: GoogleFonts.aBeeZee(
                                                  fontSize: 16,
                                                  textStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              getFileSize(index),
                                            ],
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Visibility(
                                              visible: isSelected,
                                              child: Checkbox(
                                                splashRadius: 20,
                                                activeColor: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                side: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 2,
                                                ),
                                                checkColor: Theme.of(context)
                                                    .primaryIconTheme
                                                    .color,
                                                shape: const CircleBorder(),
                                                value: selecteCheckBoxdItems[
                                                    index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selecteCheckBoxdItems[
                                                        index] = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 12),
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 2,
                                  thickness: 2,
                                  endIndent: 50,
                                  indent: 50,
                                );
                              },
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (!isSelected) {
                                        if (FileManager.isFile(files[index])) {
                                          manageFileExtensions(
                                            files[index].path.toLowerCase(),
                                            context,
                                            index,
                                          );
                                        } else {
                                          currentPath =
                                              files[index].parent.path;
                                          enterFolder(files[index].path);
                                        }
                                      } else {
                                        setState(() {
                                          selecteCheckBoxdItems[index] =
                                              !selecteCheckBoxdItems[index];
                                        });
                                      }
                                    },
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      selected: selecteCheckBoxdItems[index],
                                      selectedTileColor:
                                          Theme.of(context).colorScheme.primary,
                                      leading: Stack(
                                        children: [
                                          getFolderIcon(files[index].path),
                                          Transform.scale(
                                            scale: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, left: 5),
                                              child: Visibility(
                                                visible: isSelected,
                                                child: Checkbox(
                                                  splashRadius: 20,
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  side: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  checkColor: Theme.of(context)
                                                      .primaryIconTheme
                                                      .color,
                                                  shape: const CircleBorder(),
                                                  value: selecteCheckBoxdItems[
                                                      index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selecteCheckBoxdItems[
                                                          index] = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        setFileName(files, index),
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 15,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                      subtitle: getFileSize(index),
                                      trailing: Text(
                                        files[index]
                                            .statSync()
                                            .accessed
                                            .toString()
                                            .split('.')[0]
                                            .replaceAll(RegExp('-'), '/')
                                            .replaceAll(
                                                RegExp(r' '), '   \n   '),
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 13,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 2.0, left: 5.0, top: 23),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).colorScheme.primary),
                          shadowColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).colorScheme.background)),
                      onPressed: () {
                        setState(() {
                          changeView = (changeView == ChangeViewDirectory.Grid)
                              ? ChangeViewDirectory.List
                              : ChangeViewDirectory.Grid;
                        });
                      },
                      child: changeDirectoryViewIcon(changeView),
                    ),
                  ),
                  Visibility(
                    visible: files.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 3.0, right: 5.0, top: 23),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primary),
                            shadowColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.background),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                isSelected = false;
                                clearSelection();
                              } else {
                                isSelected = true;
                              }
                            });
                          },
                          child: Text(
                            isSelected ? "Clear" : "Select",
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ).tr(),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selecteCheckBoxdItems.contains(true),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 3.0, right: 90, top: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(10),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            onPressed: () {
                              final List<FileSystemEntity> deleteFiles = [];
                              for (var i = 0;
                                  i < selecteCheckBoxdItems.length;
                                  i++) {
                                if (selecteCheckBoxdItems[i]) {
                                  deleteFiles.add(files[i]);
                                }
                              }
                              showDialog(
                                context: context,
                                builder: (context) => FileDeletePage(
                                  checkedBoxesList: selecteCheckBoxdItems,
                                  deleteFiles: deleteFiles,
                                ),
                              ).then((_) {
                                setState(() {
                                  enterFolder(currentPath!);
                                  // isSelected = false;
                                  clearSelection();
                                });
                              });
                            },
                            child: Icon(
                              Icons.delete_rounded,
                              color: Theme.of(context).colorScheme.background,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            files.isNotEmpty ? "${files.length} item" : "",
                            style: GoogleFonts.andika(
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 70, right: 76, top: 3),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              !getArgs.containsKey('path')
                                  ? currentPath
                                          ?.replaceAll(
                                              RegExp(
                                                  syncMagnetRootDirectory.path),
                                              "SyncMagnet")
                                          .replaceAll(RegExp(r'/'), ' > ') ??
                                      ''
                                  : currentPath
                                          ?.substring(1)
                                          .replaceAll(
                                              RegExp(r'storage/emulated/0'),
                                              'Device')
                                          .replaceAll(RegExp(r'/'), ' > ') ??
                                      '',
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _googleADS.bannerAd!.size.width.toDouble(),
                height: _googleADS.bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _googleADS.bannerAd!),
              ),
            ),
            Visibility(
              visible: files.isNotEmpty,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 75),
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.1,
                            blurRadius: 20,
                            color: Theme.of(context).colorScheme.background,
                            offset: const Offset(0, 5))
                      ],
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PopupMenuButton(
                      color: Theme.of(context).colorScheme.background,
                      elevation: 3,
                      splashRadius: 3,
                      shadowColor: Theme.of(context).colorScheme.background,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          onTap: () => showModalBottomSheet(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            elevation: 3,
                            barrierColor: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.8),
                            context: context,
                            builder: (context) => SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20.0),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.sort_by_alpha_rounded,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      title: Text(
                                        'Name',
                                        style: GoogleFonts.comfortaa(
                                          fontWeight: FontWeight.w900,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ).tr(),
                                      trailing: onNameSort
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            )
                                          : null,
                                      onTap: () {
                                        files.sort((a, b) =>
                                            a.uri.pathSegments.last.compareTo(
                                                b.uri.pathSegments.last));
                                        onNameSort = true;
                                        onLargestSizeSort = false;
                                        onSmallestSizeSort = false;
                                        onFolderNameSort = false;
                                        Navigator.pop(context);
                                        enterFolder(currentPath!);
                                        setState(() {});
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.swap_vert_rounded,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      title: Text(
                                        'Size (Largest)',
                                        style: GoogleFonts.comfortaa(
                                          fontWeight: FontWeight.w900,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ).tr(),
                                      trailing: onLargestSizeSort
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            )
                                          : null,
                                      onTap: () {
                                        files.sort((a, b) => b
                                            .statSync()
                                            .size
                                            .compareTo(a.statSync().size));
                                        onLargestSizeSort = true;
                                        onSmallestSizeSort = false;
                                        onNameSort = false;
                                        onFolderNameSort = false;
                                        Navigator.pop(context);
                                        enterFolder(currentPath!);
                                        setState(() {});
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.swap_vert_rounded,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      title: Text(
                                        'Size (Smallest)',
                                        style: GoogleFonts.comfortaa(
                                          fontWeight: FontWeight.w900,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ).tr(),
                                      trailing: onSmallestSizeSort
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            )
                                          : null,
                                      onTap: () {
                                        files.sort((a, b) => a
                                            .statSync()
                                            .size
                                            .compareTo(b.statSync().size));
                                        onSmallestSizeSort = true;
                                        onLargestSizeSort = false;
                                        onNameSort = false;
                                        onFolderNameSort = false;
                                        Navigator.pop(context);
                                        enterFolder(currentPath!);
                                        setState(() {});
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.folder_copy_rounded,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      title: Text(
                                        "Only Folder See",
                                        style: GoogleFonts.comfortaa(
                                          fontWeight: FontWeight.w900,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ).tr(),
                                      onTap: () {
                                        files = files
                                            .whereType<Directory>()
                                            .toList();
                                        onFolderNameSort = true;
                                        onLargestSizeSort = false;
                                        onSmallestSizeSort = false;
                                        onNameSort = false;
                                        Navigator.pop(context);
                                        enterFolder(currentPath!);
                                        setState(() {});
                                      },
                                      trailing: onFolderNameSort
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            )
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            "Sort By",
                            style: GoogleFonts.comfortaa(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ).tr(),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                CreateFolderPage(path: (currentPath!)),
                          ).then(
                              (_) => setState(() => enterFolder(currentPath!))),
                          child: Text(
                            "New Folder",
                            style: GoogleFonts.comfortaa(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ).tr(),
                        ),
                      ],
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
        drawerEdgeDragWidth: 0,
        floatingActionButton:
            getArgs['client'].isTransfer && getArgs['client'].isConnected
                ? FloatingActionButton(
                    onPressed: () async {
                      if (!isSelected) {
                        FilePickerResult? fPicker =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.any,
                        );
                        if (fPicker!.files.isNotEmpty) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FileSendPage(
                                client: getArgs['client'],
                                files: fPicker.paths
                                    .map((path) => File(path!))
                                    .toList(),
                              );
                            },
                          );
                        }
                      } else {
                        var items = await selectedItems();
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return FileSendPage(
                              client: getArgs['client'],
                              files: items,
                            );
                          },
                        );
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.file_upload_outlined,
                      size: 35,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                : null,
        drawer: const DrawerPage(),
      ),
    );
  }

  Icon changeDirectoryViewIcon(ChangeViewDirectory viewMode) {
    switch (viewMode) {
      case ChangeViewDirectory.Grid:
        // print("grid");
        return Icon(
          Icons.grid_view_rounded,
          color: Theme.of(context).colorScheme.background,
        );
      case ChangeViewDirectory.List:
        // print("list");
        return Icon(
          Icons.view_list_rounded,
          color: Theme.of(context).colorScheme.background,
        );
    }
  }

  Text getFileSize(int index) {
    if (files[index].statSync().type != FileSystemEntityType.directory) {
      return Text(
        formatSize(files[index].statSync().size),
        style: GoogleFonts.andika(
          textStyle: TextStyle(
              fontSize: 12, color: Theme.of(context).colorScheme.secondary),
        ),
      );
    } else {
      return const Text("");
    }
  }

  void manageFileExtensions(String fileName, BuildContext context, int index) {
    if (fileName.endsWith(".png") ||
        fileName.endsWith(".jpg") ||
        fileName.endsWith(".jpeg") ||
        fileName.endsWith(".gif")) {
      Navigator.of(context).pushNamed("/image",
          arguments: {"entities": files[index], "client": getArgs['client']});
      return;
    }
    if (fileName.endsWith(".pdf")) {
      Navigator.of(context).pushNamed("/pdf",
          arguments: {"entities": files[index], "client": getArgs['client']});
      return;
    }
    if (fileName.endsWith(".mp4")) {
      Navigator.of(context).pushNamed("/video",
          arguments: {"entities": files[index], "client": getArgs['client']});
      return;
    }
    if (fileName.endsWith(".mp3") || fileName.endsWith(".wav")) {
      Navigator.of(context).pushNamed("/music", arguments: {
        "entities": files[index],
        "client": getArgs['client'],
        "music_base_path": syncMagnetRootDirectory
      });
      return;
    }
    if (fileName.endsWith(".zip")) {
      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 3,
        barrierColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
        context: context,
        builder: (context) => SizedBox(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Compressed {} file.",
                  style: GoogleFonts.comfortaa(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ).tr(args: [path.basename(fileName).toUpperCase()]),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.background),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () async => await extractArchiveData(
                          index, path.extension(fileName)),
                      child: Text(
                        "Extract",
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ).tr(),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.background),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ).tr(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      setState(() {});
      return;
    } else {
      try {
        File(fileName).readAsStringSync();
        Navigator.of(context).pushNamed("/text",
            arguments: {"entities": files[index], "client": getArgs['client']});
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Can't Open File",
            style: GoogleFonts.comfortaa(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ).tr(),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      }
    }
  }

  Future<void> extractArchiveData(int fileIndex, String extension) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          title: Text(
            "Extracting Archive",
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          content: Container(
            height: 30,
            width: 20,
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Theme.of(context).colorScheme.primary,
            )),
          ),
        ),
      ),
    );
    final zipArchiveDirectory = Directory(
        "${syncMagnetRootDirectory.path}/${path.basenameWithoutExtension(files[fileIndex].path)}");

    if (!(await zipArchiveDirectory.exists())) {
      await zipArchiveDirectory.create(recursive: true);

      File file = File(files[fileIndex].path);
      Archive? archive;

      if (extension == '.zip') {
        archive = ZipDecoder().decodeBytes(await file.readAsBytes());
      } else if (extension == '.tar') {
        archive = TarDecoder().decodeBytes(await file.readAsBytes());
      }

      for (final entry in archive!) {
        if (entry.isFile) {
          final data = entry.content as List<int>;
          final filePath = path.join(zipArchiveDirectory.path, entry.name);
          await File(filePath).writeAsBytes(data, flush: true);
        } else {
          final directoryPath = path.join(zipArchiveDirectory.path, entry.name);
          await Directory(directoryPath).create(recursive: true);
        }
      }
      setState(() => enterFolder(currentPath!));
    }
    Navigator.of(context).pop();
    Future.delayed(
        const Duration(milliseconds: 500), () => Navigator.of(context).pop());
  }

  Future<List<File>> selectedItems() async {
    List<File> selectedFiles = [];
    for (var i = 0; i < selecteCheckBoxdItems.length; i++) {
      if (selecteCheckBoxdItems[i] &&
          (await files[i].stat()).type != FileSystemEntityType.directory) {
        selectedFiles.add(files[i] as File);
      }
    }
    return selectedFiles;
  }

  void clearSelection() {
    setState(() {
      selecteCheckBoxdItems.clear();
      selecteCheckBoxdItems = List.generate(files.length, (index) => false);
    });
  }

  void enterFolder(String folder) {
    setState(() {
      files = Directory(folder).listSync();
      currentPath = folder;
      files.removeWhere((element) => path.basename(element.path) == 'Android');
      selecteCheckBoxdItems = List.generate(files.length, (index) => false);
      if (onNameSort) {
        files.sort((a, b) =>
            a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last));
      }
      if (onLargestSizeSort) {
        files.sort(
          (a, b) => b.statSync().size.compareTo(a.statSync().size),
        );
      }
      if (onSmallestSizeSort) {
        files.sort(
          (a, b) => a.statSync().size.compareTo(b.statSync().size),
        );
      }
      if (onFolderNameSort) {
        files = files.whereType<Directory>().toList();
      }
    });
  }

  String setFileName(List<FileSystemEntity> entities, int index) {
    String baseName =
        FileManager.basename(files[index], showFileExtension: true);
    String result = "";
    if (baseName.length > 14) {
      result = "${baseName.substring(0, 14)}...";
    } else {
      result = baseName;
    }
    return result;
  }

  Future<Directory> getSyncMagnetDirectory() async {
    Directory syncMagnetDirectory =
        Directory('${(await getExternalStorageDirectory())!.path}/SyncMagnet');

    if (!(await syncMagnetDirectory.exists())) {
      await syncMagnetDirectory.create(recursive: false);
    }
    if (getArgs.containsKey('path')) {
      files = getArgs['path'];
      Directory appDirectory =
          (await getExternalStorageDirectory())!.parent.parent.parent.parent;
      // print(appDirectory);
      return appDirectory;
    } else {
      await for (FileSystemEntity fileSystem in syncMagnetDirectory.list()) {
        files.add(fileSystem);
      }

      return syncMagnetDirectory;
    }
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
      return fileDIRECTORYicon();
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
        try {
          File(basename).readAsStringSync();
        } catch (e) {
          return fileLOCKicon();
        }
        return fileTEXTicon();
      }
    }
  }

  Stack fileArchiveicon() {
    return Stack(
      children: [
        Padding(
          padding: changeView == ChangeViewDirectory.Grid
              ? const EdgeInsets.all(10.0)
              : const EdgeInsets.only(right: 3),
          child: Icon(
            Icons.folder_zip_rounded,
            size: changeView == ChangeViewDirectory.Grid ? 120 : 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileDIRECTORYicon() {
    return Stack(
      children: [
        Padding(
          padding: changeView == ChangeViewDirectory.Grid
              ? const EdgeInsets.all(10.0)
              : const EdgeInsets.only(right: 3),
          child: Icon(
            Icons.folder,
            size: changeView == ChangeViewDirectory.Grid ? 130 : 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
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
            size: changeView == ChangeViewDirectory.Grid ? 130 : 65,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileLOCKicon() {
    return Stack(
      children: [
        Padding(
          padding: changeView == ChangeViewDirectory.Grid
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.only(left: 7),
          child: Icon(
            Icons.lock_rounded,
            size: changeView == ChangeViewDirectory.Grid ? 100 : 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileEXEicon() {
    return Stack(
      children: [
        Padding(
          padding: changeView == ChangeViewDirectory.Grid
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.only(left: 10),
          child: Container(
            alignment: Alignment.center,
            width: changeView == ChangeViewDirectory.Grid ? 98 : 50,
            height: changeView == ChangeViewDirectory.Grid ? 98 : 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                ".EXE",
                style: GoogleFonts.lilitaOne(
                  fontSize: changeView == ChangeViewDirectory.Grid ? 40 : 20,
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileAPKicon() {
    return Stack(
      children: [
        if (changeView == ChangeViewDirectory.Grid)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.center,
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Icon(
                  Icons.android_rounded,
                  color: Theme.of(context).colorScheme.background,
                  size: 90,
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Icon(
                  Icons.android_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
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
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileTEXTicon() {
    return Stack(
      children: [
        Padding(
          padding: changeView == ChangeViewDirectory.Grid
              ? const EdgeInsets.all(0)
              : const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.text_snippet_sharp,
            size: changeView == ChangeViewDirectory.Grid ? 130 : 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 83, right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileVIDEOicon() {
    return Stack(
      children: [
        Icon(
          Icons.audio_file_rounded,
          size: changeView == ChangeViewDirectory.Grid ? 130 : 60,
          color: Theme.of(context).colorScheme.primary,
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 83, right: 40),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileGIFicon() {
    return Stack(
      children: [
        Icon(
          Icons.gif_box_rounded,
          size: changeView == ChangeViewDirectory.Grid ? 130 : 65,
          color: Theme.of(context).colorScheme.primary,
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: changeView == ChangeViewDirectory.Grid ? 83 : 12,
                right: changeView == ChangeViewDirectory.Grid ? 40 : 20),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
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
              padding: changeView == ChangeViewDirectory.Grid
                  ? const EdgeInsets.all(16.0)
                  : const EdgeInsets.only(left: 10),
              child: Container(
                alignment: Alignment.center,
                width: changeView == ChangeViewDirectory.Grid ? 98 : 50,
                height: changeView == ChangeViewDirectory.Grid ? 98 : 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "PDF",
                    style: GoogleFonts.lilitaOne(
                      fontSize:
                          changeView == ChangeViewDirectory.Grid ? 40 : 20,
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: changeView == ChangeViewDirectory.Grid ? 100 : 50,
              right: changeView == ChangeViewDirectory.Grid ? 100 : 35,
            ),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Stack fileMP4icon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.movie_creation_rounded,
          size: changeView == ChangeViewDirectory.Grid ? 130 : 65,
          color: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14.0, left: 6),
          child: Icon(
            Icons.play_arrow_outlined,
            size: changeView == ChangeViewDirectory.Grid ? 50 : 30,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: changeView == ChangeViewDirectory.Grid ? 90 : 30,
              right: changeView == ChangeViewDirectory.Grid ? 120 : 40,
            ),
            child: Icon(
              Icons.indeterminate_check_box,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
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
