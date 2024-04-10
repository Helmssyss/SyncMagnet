// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final VideoPlayerController _videoPlayerController;
  late final Map<String, dynamic> getArgs;
  late final ChewieController chewieController;
  late final GoogleADS _googleADS;
  late final Future<void> _videoPlayerControllerInitialized;

  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _googleADS.interstitialAdLoad();
    Future.delayed(
      Duration(
        seconds: Random.secure().nextInt(4) + 1,
      ),
      () => _googleADS.interstitialAd!.show(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _videoPlayerController = VideoPlayerController.file(
      getArgs["entities"] as File,
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
    );

    chewieController = ChewieController(
      materialProgressColors: ChewieProgressColors(
        bufferedColor: Theme.of(context).colorScheme.primary,
        handleColor: Theme.of(context).colorScheme.secondary,
        playedColor: Theme.of(context).primaryIconTheme.color!,
      ),
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    _videoPlayerControllerInitialized =
        _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Theme.of(context).colorScheme.background,
            )),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Video Player",
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
      ),
      body: FutureBuilder(
        future: _videoPlayerControllerInitialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: chewieController,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
                  })
              : null,
    );
  }
}
