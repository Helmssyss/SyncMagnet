import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sync_magnet/src/services/google_ads.dart';
import 'package:sync_magnet/widgets/file_send_page.dart';

class MusicViewPage extends StatefulWidget {
  const MusicViewPage({Key? key}) : super(key: key);

  @override
  State<MusicViewPage> createState() => _MusicViewPageState();
}

class _MusicViewPageState extends State<MusicViewPage> {
  late final Map<String, dynamic> getArgs;
  late final GoogleADS _googleADS;
  late AudioPlayer _audioPlayer;
  late String fileName;
  Duration audioTotalDuration = Duration.zero;
  Duration audioCurrentDuration = Duration.zero;
  int fileSize = 0;
  int currentPlayMusicIndex = -1;
  bool isPlaying = false;
  bool isLoopMode = false;
  List<FileSystemEntity> musicFiles = [];
  List<FileSystemEntity> shuffledMusicFiles = [];
  double volume = 0.3;

  @override
  void initState() {
    super.initState();
    _googleADS = GoogleADS();
    _audioPlayer = AudioPlayer();
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
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    fileName = getArgs["entities"]
        .path
        .split('/')[getArgs["entities"].path.split('/').length - 1];
    for (var element in getArgs["music_base_path"].listSync(recursive: true)) {
      var name = element.path.split('/').last;
      if (name.endsWith(".wav") || name.endsWith(".mp3")) {
        musicFiles.add(element);
      }
    }
    loadMusicData();
    _audioPlayer.positionStream.listen(
      (Duration position) {
        if (position >= _audioPlayer.duration!) {
          if (isLoopMode) {
            playNext();
          } else {
            _audioPlayer.seek(Duration.zero);
            // _audioPlayer.play();
          }
        }
        setState(() {
          audioCurrentDuration = position;
        });
      },
    );
  }

  void playNext() {
    int nextIndex;
    if (currentPlayMusicIndex == -1) {
      currentPlayMusicIndex = 0;
      nextIndex = currentPlayMusicIndex + 1;
    } else {
      nextIndex = currentPlayMusicIndex + 1;
    }
    if (nextIndex >= musicFiles.length) {
      nextIndex = 0;
    }
    playMusicAtIndex(nextIndex);
  }

  void playMusicAtIndex(int index) async {
    await _audioPlayer.setFilePath(musicFiles[index].path);
    await _audioPlayer.load();
    audioTotalDuration = _audioPlayer.duration!;
    fileSize = await File(musicFiles[index].path).length();
    _audioPlayer.play();
    fileName = musicFiles[index].path.split('/').last;
    isPlaying = true;
    currentPlayMusicIndex = index;
    setState(() {});
  }

  void playPrevious() async {
    int previousIndex = currentPlayMusicIndex - 1;
    if (previousIndex < 0) previousIndex = musicFiles.length - 1;
    playMusicAtIndex(previousIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Music Player",
          style: GoogleFonts.lilitaOne(
            shadows: [
              Shadow(
                blurRadius: 3,
                color: Theme.of(context).colorScheme.background,
              )
            ],
            fontSize: 25,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 13),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 100),
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(140),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary,
                        blurRadius: 3,
                        spreadRadius: 5,
                        blurStyle: BlurStyle.normal,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.music_note_rounded,
                    color: Theme.of(context).colorScheme.background,
                    size: 160,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.background,
                        blurRadius: 30,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 9.0),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: volume,
                          onChanged: (value) {
                            setState(() {
                              _audioPlayer.setVolume(value);
                              volume = _audioPlayer.volume;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 180.0, left: 12),
                      child: Icon(
                        getVolumeIcon(_audioPlayer.volume),
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Text(
            fileName,
            style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Text(
            formatSize(fileSize),
            style: GoogleFonts.andika(
              textStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(audioCurrentDuration),
                  style: GoogleFonts.andika(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isLoopMode) {
                      _audioPlayer.setLoopMode(LoopMode.all);
                      isLoopMode = false;
                    } else {
                      _audioPlayer.setLoopMode(LoopMode.off);
                      isLoopMode = true;
                    }
                    setState(() {});
                  },
                  splashRadius: 20,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 30,
                  icon: Icon(
                    isLoopMode ? Icons.repeat_on : Icons.repeat_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  formatTime(audioTotalDuration),
                  style: GoogleFonts.andika(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Slider(
              min: 0,
              max: audioTotalDuration.inSeconds.toDouble(),
              value: audioCurrentDuration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    playPrevious();
                  },
                  splashRadius: 20,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 30,
                  icon: Icon(
                    Icons.skip_previous,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  )),
              IconButton(
                splashRadius: 20,
                splashColor: Theme.of(context).colorScheme.secondary,
                iconSize: 30,
                onPressed: () {
                  if (_audioPlayer.position.inSeconds.toDouble() +
                          const Duration(seconds: 10).inSeconds.toDouble() >
                      audioTotalDuration.inSeconds.toDouble()) {
                    _audioPlayer.seek(audioTotalDuration);
                  } else {
                    _audioPlayer.seek(
                        _audioPlayer.position + const Duration(seconds: 10));
                  }
                },
                icon: Icon(
                  Icons.forward_10_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (isPlaying) {
                    _audioPlayer.pause();
                    isPlaying = false;
                  } else {
                    _audioPlayer.play();
                    isPlaying = true;
                  }
                  setState(() {});
                },
                splashRadius: 30,
                splashColor: Theme.of(context).colorScheme.secondary,
                iconSize: 60,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
              IconButton(
                splashRadius: 20,
                splashColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  if (_audioPlayer.position.inSeconds.toDouble() -
                          const Duration(seconds: 10).inSeconds.toDouble() <
                      0.0) {
                    _audioPlayer.seek(const Duration(seconds: 0));
                  } else {
                    _audioPlayer.seek(
                        _audioPlayer.position - const Duration(seconds: 10));
                  }
                },
                iconSize: 30,
                icon: Icon(
                  Icons.replay_10_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    playNext();
                  },
                  splashRadius: 20,
                  splashColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 30,
                  icon: Icon(
                    Icons.skip_next,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  )),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: musicFiles.length,
              itemBuilder: (context, index) {
                String listViewFileName =
                    musicFiles[index].path.split('/').last;
                return InkWell(
                  onTap: () async {
                    await _audioPlayer.setFilePath(musicFiles[index].path);
                    await _audioPlayer.load();
                    audioTotalDuration = _audioPlayer.duration!;
                    fileSize = await File(musicFiles[index].path).length();
                    _audioPlayer.play();
                    fileName = listViewFileName;
                    isPlaying = true;
                    currentPlayMusicIndex = index;
                    setState(() {});
                  },
                  child: ListTile(
                    leading: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary,
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  blurStyle: BlurStyle.normal,
                                )
                              ]),
                          child: Icon(
                            Icons.music_note_rounded,
                            color: Theme.of(context).colorScheme.background,
                            size: 30,
                            shadows: [
                              Shadow(
                                color: Theme.of(context).colorScheme.background,
                                blurRadius: 30,
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: fileName == listViewFileName,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 12),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                              shadows: [
                                Shadow(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    blurRadius: 4)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(
                      listViewFileName,
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      formatSize(
                        File(musicFiles[index].path).lengthSync(),
                      ),
                      style: GoogleFonts.andika(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: _googleADS.bannerAd!.size.width.toDouble(),
            height: _googleADS.bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _googleADS.bannerAd!),
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
                    size: 40,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  onPressed: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return FileSendPage(
                          client: getArgs["client"],
                          files: currentPlayMusicIndex != -1
                              ? [musicFiles[currentPlayMusicIndex] as File]
                              : [getArgs['entities'] as File],
                        );
                      },
                    );
                  },
                )
              : null,
    );
  }

  Future<void> loadMusicData() async {
    fileSize = await File(getArgs["entities"].path).length();
    await _audioPlayer.setFilePath(getArgs["entities"].path);
    await _audioPlayer.load();
    audioTotalDuration = _audioPlayer.duration!;
  }

  IconData getVolumeIcon(double volume) {
    if (volume == 0.0) {
      return Icons.volume_off_rounded;
    } else if (volume < 0.33) {
      return Icons.volume_mute_rounded;
    } else if (volume < 0.66) {
      return Icons.volume_down_rounded;
    } else {
      return Icons.volume_up_rounded;
    }
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

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
