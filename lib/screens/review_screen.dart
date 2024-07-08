import 'dart:io';

import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/home.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

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
        reviewDescriptions.add(element.description);
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

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    reviewListCreate();
    super.initState();
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
                    return Stack(
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
                                    horizontal: 12, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reviewTexts[index],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    reviewDescriptions[index] != null ||
                                            reviewDescriptions[index] != ''
                                        ? Text(
                                            reviewDescriptions[index],
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Container(
                                            width: 200,
                                            height: 10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // setState(() {
                                                    //   homePathOfVoice =
                                                    //       voiceList[index];
                                                    // });
                                                    // homeSetAudio();
                                                    // homeAudioPlayer.resume();
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    width: 40,
                                                    height: 40,
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // homeAudioPlayer.pause();
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    width: 40,
                                                    height: 40,
                                                    child: const Icon(
                                                      Icons.pause,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
