import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sync_magnet/src/services/client.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:sync_magnet/widgets/close_page.dart';
import 'package:sync_magnet/widgets/connect_server_page.dart';
import 'package:sync_magnet/widgets/disconnect_page.dart';
import 'package:sync_magnet/widgets/drawer_page.dart';
import 'package:sync_magnet/widgets/file_accept_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final SyncSocketClient client;
  late final GoogleADS _googleADS;
  late Icon icon;
  bool isAlertDialogOpen = false;
  late Stream<void> backProcessLoop;
  late StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    checkNetConnection();
    client = SyncSocketClient();
    magnetFolder();
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
    icon = Icon(Icons.devices_rounded,
        color: Theme.of(context).colorScheme.background);
    backProcessLoop = Stream<void>.periodic(const Duration(milliseconds: 100));
    subscription = backProcessLoop.listen((event) {
      // print("EVENT -> ASDQWEQE backProcessLoop");
      if (client.clientIsDisconnect) {
        client.clientIsDisconnect = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const CallDisconnectLoadScreen();
          },
        ).then((_) {
          setState(() {
            client.isConnected = false;
            client.isClose = true;
          });
        });
      }
      if (client.isGetFile && !isAlertDialogOpen) {
        isAlertDialogOpen = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: FileAcceptPage(
                client: client,
              ),
            );
          },
        ).then((_) {
          isAlertDialogOpen = false;
          client.isGetFile = false;
          setState(() {});
        });
      }
      if (client.isGetFileCompleted) {
        setState(() {
          client.isGetFileCompleted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          return true;
        } else {
          showDialog(
            context: context,
            builder: (context) =>
                CloseAlertPage(mainStreamSubscription: subscription),
          );
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Sync Magnet",
            style: GoogleFonts.lilitaOne(
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Theme.of(context).colorScheme.background,
                )
              ],
              fontSize: 30,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              iconColor: Theme.of(context).colorScheme.background,
              color: Theme.of(context).colorScheme.background,
              iconSize: 30,
              padding: const EdgeInsets.only(bottom: 3),
              onSelected: (value) async => onPopupHandleClick(value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      client.isConnected
                          ? Icon(Icons.phonelink_off_sharp,
                              color: Theme.of(context).colorScheme.primary)
                          : Icon(Icons.devices,
                              color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      client.isConnected
                          ? Text(
                              "Disconnect",
                              style: GoogleFonts.comfortaa(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ).tr()
                          : Text(
                              "Connect to Pc",
                              style: GoogleFonts.comfortaa(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ).tr()
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.share_rounded,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        "Share",
                        style: GoogleFonts.comfortaa(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ).tr()
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.question_mark_rounded,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        "Feedback",
                        style: GoogleFonts.comfortaa(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ).tr()
                    ],
                  ),
                )
              ],
            )
          ],
          leading: Builder(
            builder: (context) => IconButton(
                splashRadius: 20,
                highlightColor: Colors.transparent,
                onPressed: () {
                  return Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.segment_rounded,
                  color: Theme.of(context).colorScheme.background,
                  size: 30,
                )),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const Spacer(flex: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      subscription.pause();
                      Navigator.of(context).pushNamed('/view_directory',
                          arguments: {
                            'client': client
                          }).then((value) => subscription.resume());
                    },
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.folder,
                                color: Theme.of(context).colorScheme.primary,
                                size: 120,
                                shadows: [
                                  Shadow(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    blurRadius: 12,
                                  )
                                ],
                              ),
                              Icon(
                                Icons.electric_bolt_rounded,
                                size: 50,
                                color: Theme.of(context).colorScheme.background,
                              )
                            ],
                          ),
                          Text(
                            "Magnet Folder",
                            style: GoogleFonts.comfortaa(
                              fontWeight: FontWeight.w900,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ).tr()
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      subscription.pause();
                      Navigator.of(context).pushNamed('/view_directory',
                          arguments: {
                            'client': client,
                            "path": await _listFilesInDirectory()
                          }).then(
                        (value) => subscription.resume(),
                      );
                    },
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.folder,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 120,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      blurRadius: 12,
                                    )
                                  ]),
                              Icon(
                                Icons.android,
                                color: Theme.of(context).colorScheme.background,
                                size: 70,
                              )
                            ],
                          ),
                          Text(
                            "Device",
                            style: GoogleFonts.comfortaa(
                              fontWeight: FontWeight.w900,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ).tr()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _googleADS.bannerAd!.size.width.toDouble(),
                  height: _googleADS.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _googleADS.bannerAd!),
                ),
              ),
            ],
          ),
        ),
        drawerEdgeDragWidth: 0,
        drawer: const DrawerPage(),
      ),
    );
  }

  Future<List<FileSystemEntity>> _listFilesInDirectory() async {
    List<FileSystemEntity> appDirectory = (await getExternalStorageDirectory())!
        .parent
        .parent
        .parent
        .parent
        .listSync();
    return appDirectory;
  }

  void onPopupHandleClick(int value) {
    switch (value) {
      case 0:
        if (client.isConnected) {
          // ignore: use_build_context_synchronously
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => DisconnectPage(client: client)).then((_) {
            if (client.isConnected) {
              icon = Icon(
                Icons.phonelink_off_sharp,
                color: Theme.of(context).colorScheme.background,
              );
              setState(() {});
            }
          });
        } else {
          showDialog(
              context: context,
              builder: (context) => ConnectPopupPage(client: client)).then((_) {
            if (client.isConnected) {
              icon = Icon(
                Icons.phonelink_off_sharp,
                color: Theme.of(context).colorScheme.background,
              );
              setState(() {});
            }
          });
        }
        break;

      case 1:
        Share.share('https://github.com/Helmssyss/SyncMagnet',
            subject: 'Look what I made!');
        break;

      default:
        break;
    }
  }

  Future<void> checkNetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
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
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            title: Text("İnternet Bağlantısı Yok",
                style: GoogleFonts.comfortaa(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )),
            content: Text(
              "Uygulamayı kullanabilmek için internet bağlantısına ihtiyaç duyulmaktadır.",
              style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  subscription.pause();
                  subscription.cancel();
                  SystemNavigator.pop();
                },
                child: Text("Tamam",
                    style: GoogleFonts.comfortaa(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )).tr(),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> magnetFolder() async {
    final Directory? d = await getExternalStorageDirectory();
    client.folder = "${d!.path}/SyncMagnet";
    final Directory syncMagnetDirectory = Directory(client.folder);
    if (!(await syncMagnetDirectory.exists())) {
      await syncMagnetDirectory.create(recursive: false);
    }
  }
}
