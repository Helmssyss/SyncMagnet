import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sync_magnet/src/services/google_ads.dart';

class OpenImage extends StatefulWidget {
  const OpenImage({super.key});

  @override
  State<OpenImage> createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  late final Map<String, dynamic> getArgs =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late final GoogleADS _googleADS;
  bool onTap = false;

  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _googleADS.loadBannerAd(
      adLoaded: () {
        setState(() {});
      },
    );
    _googleADS.interstitialAdLoad();
    Future.delayed(
      Duration(seconds: Random.secure().nextInt(4) + 1),
      () => _googleADS.interstitialAd!.show(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: onTap
          ? null
          : AppBar(
              title: Text(
                getArgs["entities"]
                    .path
                    .split('/')[getArgs["entities"].path.split('/').length - 1],
                style: GoogleFonts.lilitaOne(
                  fontSize: 25,
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Theme.of(context).colorScheme.background,
                  )),
              backgroundColor: Theme.of(context).colorScheme.primary),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (onTap) {
                setState(() {
                  onTap = false;
                });
              } else {
                setState(() {
                  onTap = true;
                });
              }
            },
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              imageProvider: FileImage(getArgs["entities"]),
              maxScale: 2.0,
              minScale: PhotoViewComputedScale.contained,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _googleADS.bannerAd!.size.width.toDouble(),
              height: _googleADS.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _googleADS.bannerAd!),
            ),
          )
        ],
      ),
      drawerEdgeDragWidth: 0,
      floatingActionButton:
          getArgs['client'].isTransfer && getArgs['client'].isConnected
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.file_upload_outlined,
                    size: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  onPressed: () async {
                    await getArgs["client"].sendSelectFile(
                      file_: getArgs["entities"] as File,
                    );
                  },
                )
              : null,
    );
  }
}
