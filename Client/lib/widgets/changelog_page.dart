import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:sync_magnet/src/services/sync_http_client.dart';

class ChangelogPage extends StatefulWidget {
  const ChangelogPage({super.key});

  @override
  State<ChangelogPage> createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  late final GoogleADS _googleADS =
      ModalRoute.of(context)!.settings.arguments as GoogleADS;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _googleADS.interstitialAdLoad();

    Future.delayed(
      Duration(seconds: Random.secure().nextInt(4)),
      () => _googleADS.interstitialAd!.show(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SyncHttpClient.getChangelogData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                centerTitle: true,
                title: Text(
                  "Changelog",
                  style: GoogleFonts.lilitaOne(
                    fontSize: 25,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ).tr(),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.campaign_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                ],
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).colorScheme.background,
                    )),
              ),
              body: Markdown(
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.comfortaa(
                    fontSize: 16,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  h1: Theme.of(context).textTheme.displayLarge,
                  h2: GoogleFonts.comfortaa(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  h3: GoogleFonts.comfortaa(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  listBullet: GoogleFonts.comfortaa(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              drawerEdgeDragWidth: 0,
            );
          } else {
            return const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
