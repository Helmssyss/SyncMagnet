import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PdfViewerController _pdfController;
  late final Map<String, dynamic> getArgs =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late final GoogleADS _googleADS;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _googleADS = GoogleADS();
    _googleADS.loadBannerAd(adLoaded: () {
      setState(() {});
    });
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Theme.of(context).colorScheme.background,
            )),
        title: Text(
          getArgs["entities"]
              .path
              .split('/')[getArgs["entities"].path.split('/').length - 1],
          style: GoogleFonts.lilitaOne(
            fontSize: 25,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            getArgs["entities"] as File,
            controller: _pdfController,
            enableTextSelection: true,
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
      floatingActionButton:
          getArgs['client'].isTransfer && getArgs['client'].isConnected
              ? FloatingActionButton(
                  onPressed: () {
                    getArgs["client"].sendSelectFile(
                      file_: getArgs["entities"] as File,
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
  }
}
