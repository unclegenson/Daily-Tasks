import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart' as h;

List reviewDescriptions = [];
List reviewTexts = [];
List reviewDateTimes = [];
List reviewVoiceList = [];
List reviewContainerColors = [];
List reviewBoxImages = [];
int count = 0;

void reviewListCreate() {
  reviewDescriptions.clear();
  reviewTexts.clear();
  reviewDateTimes.clear();
  reviewVoiceList.clear();
  reviewContainerColors.clear();
  reviewBoxImages.clear();
  count = 0;
  Hive.box<Notes>('notesBox').values.forEach(
    (element) {
      count++;
      if (!element.done!) {
        //! delete ! from here
        reviewDescriptions.add(element.description);
        reviewDateTimes.add({
          'day': element.day,
          'weekDay': element.weekDay,
          'mounth': element.month,
          'year': element.year
        });
        reviewVoiceList.add(element.voice);
        reviewBoxImages.add(element.image);
        reviewTexts.add(element.title);
        reviewContainerColors.add(Color.fromARGB(element.colorAlpha!,
            element.colorRed!, element.colorGreen!, element.colorBlue!));
      }
    },
  );
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

final reviewAudioPlayer = AudioPlayer();

bool isPlaying = false;

String? reviewPathOfVoice;

Duration reviewDurationOfAudio = Duration.zero;
Duration reviewAudioPosition = Duration.zero;

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    reviewAudioPlayer.onPlayerStateChanged.listen(
      (event) {
        if (this.mounted) {
          setState(() {
            // ignore: unrelated_type_equality_checks
            isPlaying = event == h.PlayerState.isPlaying;
          });
        }
      },
    );
    reviewAudioPlayer.onDurationChanged.listen((newDuration) {
      if (this.mounted) {
        setState(() {
          reviewDurationOfAudio = newDuration;
        });
      }
    });
    reviewAudioPlayer.onPositionChanged.listen((newPosition) {
      if (this.mounted) {
        setState(() {
          reviewAudioPosition = newPosition;
        });
      }
    });
    reviewListCreate();
    super.initState();
  }

  Future reviewSetAudio() async {
    reviewAudioPlayer.setSourceDeviceFile(reviewPathOfVoice!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/back2.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcATop),
                    ),
                  ),
                ),
              ),
            );
          }),
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: const MyAppBarTitle(
            title: 'Review Last Tasks',
            fontSize: 42,
          ),
          titleSpacing: 10,
          elevation: 0,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: size.height - 122,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        reviewBoxImages[index] != null
                            ? showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Transform.scale(
                                    scale: a1.value,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: AlertDialog(
                                        backgroundColor: Colors.white24,
                                        content: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: ClipRRect(
                                            child: Container(
                                              height: size.width,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                // !-------------------image------------------
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: FileImage(
                                                    File(
                                                      reviewBoxImages[index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                barrierDismissible: true,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return Container();
                                },
                              )
                            : const AboutDialog();
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: 100,
                            width: size.width - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: reviewContainerColors[index],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                reviewBoxImages[index] != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // !-------------------image------------------
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                  File(
                                                    reviewBoxImages[index],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          child: const Icon(
                                            Icons.image_not_supported_rounded,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewTexts[index],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      reviewDescriptions[index] != ''
                                          ? Text(
                                              reviewDescriptions[index],
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 6,
                                              ),
                                              child: SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          reviewPathOfVoice =
                                                              reviewVoiceList[
                                                                  index];
                                                        });
                                                        reviewSetAudio();
                                                        reviewAudioPlayer
                                                            .resume();
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                        width: 40,
                                                        height: 40,
                                                        child: const Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        reviewAudioPlayer
                                                            .pause();
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                        width: 40,
                                                        height: 40,
                                                        child: const Icon(
                                                          Icons.pause,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              '${reviewDateTimes[index]['year'].toString()} - ${reviewDateTimes[index]['mounth']} - ${reviewDateTimes[index]['day'].toString()}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
