import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/drawer_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../widgets/app_widgets.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart' as h;

List voiceList = [];

bool showSearchBar = false;
List weekDays = ['Mon', 'Tue', 'Wed', 'Tur', 'Fri', 'Sat', 'Sun'];
List texts = [];
List copyOfTexts = [];

List descriptions = [];
List copyOfDescriptions = [];

List dateTimes = [];
List copyOfDateTimes = [];

List containerColors = [];
List copyOfContainerColors = [];

List categories = [];
List copyOfCategories = [];

List searchItemIndexes = [];
bool done = false;

List copyOfBoxImage = [];
List boxImages = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? homePathOfVoice;

Duration homeDurationOfAudio = Duration.zero;
Duration homeAudioPosition = Duration.zero;
final homeAudioPlayer = AudioPlayer();

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void dispose() {
  //   homeAudioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    homeAudioPlayer.onPlayerStateChanged.listen(
      (event) {
        if (this.mounted) {
          setState(() {
            // ignore: unrelated_type_equality_checks
            isPlaying = event == h.PlayerState.isPlaying;
          });
        }
      },
    );
    homeAudioPlayer.onDurationChanged.listen((newDuration) {
      if (this.mounted) {
        setState(() {
          homeDurationOfAudio = newDuration;
        });
      }
    });
    homeAudioPlayer.onPositionChanged.listen((newPosition) {
      if (this.mounted) {
        setState(() {
          homeAudioPosition = newPosition;
        });
      }
    });
    textsListCreate();
    super.initState();
  }

  Future homeSetAudio() async {
    homeAudioPlayer.setSourceDeviceFile(homePathOfVoice!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
        backgroundColor: Colors.black87,
        appBar: AppBar(
          titleSpacing: 10,
          leading: Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
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
                        'assets/ham3.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcATop),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          elevation: 0,
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: Colors.black87,
          title: const MyAppBarTitle(
            title: 'Daily Tasks',
            fontSize: 46,
          ),
        ),
        floatingActionButton: fabWidget(),
        body: Center(
          child: texts.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/ast.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcATop),
                    ),
                    const Text(
                      'Add a new Task!',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: CustomScrollView(
                    slivers: [
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return LayoutBuilder(
                                builder: (context, constraints) {
                              return GestureDetector(
                                onLongPress: () {
                                  boxImages[index] != null
                                      ? showGeneralDialog(
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          transitionBuilder:
                                              (context, a1, a2, widget) {
                                            return Transform.scale(
                                              scale: a1.value,
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: AlertDialog(
                                                  backgroundColor:
                                                      Colors.white24,
                                                  content: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                      sigmaX: 5,
                                                      sigmaY: 5,
                                                    ),
                                                    child: ClipRRect(
                                                      child: Container(
                                                        height: size.width,
                                                        width: size.width,
                                                        decoration:
                                                            BoxDecoration(
                                                          // !-------------------image------------------
                                                          image:
                                                              DecorationImage(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            image: FileImage(
                                                              File(
                                                                boxImages[
                                                                    index],
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
                                          pageBuilder: (context, animation1,
                                              animation2) {
                                            return Container();
                                          },
                                        )
                                      : const AboutDialog();
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddNoteScreen(
                                          note: Notes(
                                            voice: voiceList[index],
                                            image: boxImages[index],
                                            id: index.toString(),
                                            title: texts[index],
                                            category: categories[index],
                                            description: descriptions[index],
                                            done: false,
                                            colorAlpha:
                                                containerColors[index].alpha,
                                            colorBlue:
                                                containerColors[index].blue,
                                            colorGreen:
                                                containerColors[index].green,
                                            colorRed:
                                                containerColors[index].red,
                                            day: dateTimes[index]['day'],
                                            hour: dateTimes[index]['hour'],
                                            minute: dateTimes[index]['minute'],
                                            month: dateTimes[index]['mount'],
                                            weekDay: dateTimes[index]
                                                ['weekDay'],
                                            year: dateTimes[index]['year'],
                                          ),
                                        );
                                      },
                                    ),
                                  ).then(
                                    (value) {
                                      textsListCreate();
                                      setState(() {});
                                    },
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: containerColors[index],
                                          //? -----------------------COLOR----------------------------
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            voiceList[index] == null
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 12,
                                                          right: 10,
                                                          top: 10,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            texts[
                                                                index], //!--------------------TEXT-----------------------
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12,
                                                                right: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            descriptions[
                                                                index], //@------------------------DESCRIPTION-------------------
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Stack(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          texts[
                                                              index], //!--------------------TEXT-----------------------
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          homePathOfVoice ==
                                                                  voiceList[
                                                                      index]
                                                              ? Slider(
                                                                  activeColor:
                                                                      Colors
                                                                          .green,
                                                                  divisions: 20,
                                                                  value: homeAudioPosition
                                                                      .inSeconds
                                                                      .toDouble(),
                                                                  onChanged:
                                                                      (value) async {
                                                                    final homeAudioPosition =
                                                                        Duration(
                                                                            seconds:
                                                                                value.toInt());
                                                                    await homeAudioPlayer
                                                                        .seek(
                                                                      homeAudioPosition,
                                                                    );
                                                                  },
                                                                  min: 0,
                                                                  max: homeDurationOfAudio
                                                                      .inSeconds
                                                                      .toDouble(),
                                                                )
                                                              : Slider(
                                                                  activeColor:
                                                                      Colors
                                                                          .green,
                                                                  divisions: 20,
                                                                  value: 0,
                                                                  onChanged:
                                                                      (value) {},
                                                                  min: 0,
                                                                  max: 100,
                                                                ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    homePathOfVoice =
                                                                        voiceList[
                                                                            index];
                                                                  });
                                                                  homeSetAudio();
                                                                  homeAudioPlayer
                                                                      .resume();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  width: 40,
                                                                  height: 40,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  homeAudioPlayer
                                                                      .pause();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  width: 40,
                                                                  height: 40,
                                                                  child:
                                                                      const Icon(
                                                                    Icons.pause,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: size.width / 10,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            backgroundColor:
                                                                Colors.green,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                16,
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              done = true;
                                                            });
                                                            PanaraConfirmDialog
                                                                .showAnimatedGrow(
                                                              context,
                                                              title: "Done?",
                                                              message:
                                                                  "Press Yes if you'he done this task.",
                                                              confirmButtonText:
                                                                  "Yes",
                                                              cancelButtonText:
                                                                  "No",
                                                              onTapCancel: () {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  done = false;
                                                                });
                                                              },
                                                              onTapConfirm: () {
                                                                Hive.box<Notes>(
                                                                        'notesBox')
                                                                    .putAt(
                                                                  index,
                                                                  Notes(
                                                                    voice: voiceList[
                                                                        index],
                                                                    image: boxImages[
                                                                        index],
                                                                    id: index
                                                                        .toString(),
                                                                    title: texts[
                                                                        index],
                                                                    category:
                                                                        categories[
                                                                            index],
                                                                    description:
                                                                        descriptions[
                                                                            index],
                                                                    done: true,
                                                                    colorAlpha:
                                                                        containerColors[index]
                                                                            .alpha,
                                                                    colorBlue:
                                                                        containerColors[index]
                                                                            .blue,
                                                                    colorGreen:
                                                                        containerColors[index]
                                                                            .green,
                                                                    colorRed:
                                                                        containerColors[index]
                                                                            .red,
                                                                    day: dateTimes[
                                                                            index]
                                                                        ['day'],
                                                                    hour: dateTimes[
                                                                            index]
                                                                        [
                                                                        'hour'],
                                                                    minute: dateTimes[
                                                                            index]
                                                                        [
                                                                        'minute'],
                                                                    month: dateTimes[
                                                                            index]
                                                                        [
                                                                        'mount'],
                                                                    weekDay: dateTimes[
                                                                            index]
                                                                        [
                                                                        'weekDay'],
                                                                    year: dateTimes[
                                                                            index]
                                                                        [
                                                                        'year'],
                                                                  ),
                                                                );
                                                                textsListCreate();

                                                                setState(() {
                                                                  done = false;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              panaraDialogType:
                                                                  PanaraDialogType
                                                                      .warning,
                                                              noImage: true,
                                                            );
                                                          },
                                                          child: done
                                                              ? SizedBox(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: colorItems[index %
                                                                        colorItems
                                                                            .length],
                                                                    strokeWidth:
                                                                        1,
                                                                  ),
                                                                )
                                                              : const Icon(
                                                                  Icons.check,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width /
                                                                      10,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    done = true;
                                                                  });
                                                                  PanaraConfirmDialog
                                                                      .showAnimatedGrow(
                                                                    context,
                                                                    title:
                                                                        "Delete this note?",
                                                                    message:
                                                                        "Are you sure you want to delete this note?",
                                                                    confirmButtonText:
                                                                        "Yes",
                                                                    cancelButtonText:
                                                                        "No",
                                                                    onTapCancel:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        done =
                                                                            false;
                                                                      });
                                                                    },
                                                                    onTapConfirm:
                                                                        () {
                                                                      Hive.box<Notes>(
                                                                              'notesBox')
                                                                          .deleteAt(
                                                                              index);
                                                                      textsListCreate();
                                                                      setState(
                                                                          () {
                                                                        done =
                                                                            false;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    panaraDialogType:
                                                                        PanaraDialogType
                                                                            .warning,
                                                                    noImage:
                                                                        true,
                                                                  );
                                                                },
                                                                child: done
                                                                    ? SizedBox(
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              colorItems[index % colorItems.length],
                                                                          strokeWidth:
                                                                              1,
                                                                        ),
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Text(
                                                    '${weekDays[dateTimes[index]['weekDay'] - 1]} - ${dateTimes[index]['day'].toString()}',
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black38,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    boxImages[index] != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(boxImages[index]),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              );
                            });
                          },
                          childCount: texts.length,
                        ),
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 2,
                          mainAxisSpacing: 7,
                          crossAxisSpacing: 7,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: const [
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                            QuiltedGridTile(2, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget fabWidget() {
    return SizedBox(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddNoteScreen(
                  note: Notes(
                    voice: '',
                    image: '',
                    category: '',
                    colorAlpha: 0,
                    day: 0,
                    description: '',
                    done: false,
                    hour: 0,
                    id: '',
                    minute: 0,
                    month: 0,
                    title: '',
                    weekDay: 0,
                    year: 0,
                    colorRed: 0,
                    colorBlue: 0,
                    colorGreen: 0,
                  ),
                );
              },
            ),
          ).then(
            (value) {
              textsListCreate();
              setState(() {
                anythingToShow = false;
              });
            },
          );
        },
        backgroundColor: Colors.grey[800],
        child: const SizedBox(
          height: 35,
          width: 35,
          // child: SvgPicture.asset(
          //   'assets/edit2.svg',
          //   colorFilter:
          //       const ColorFilter.mode(Colors.white, BlendMode.srcATop),
          // ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

void textsListCreate() {
  descriptions.clear();
  texts.clear();
  dateTimes.clear();
  categories.clear();
  voiceList.clear();
  containerColors.clear();
  boxImages.clear();

  Hive.box<Notes>('notesBox').values.forEach(
    (element) {
      if (!element.done!) {
        dateTimes.add({
          'day': element.day,
          'weekDay': element.weekDay,
          'mounth': element.month,
          'year': element.year
        });
        voiceList.add(element.voice);
        boxImages.add(element.image);
        texts.add(element.title);
        categories.add(element.category);
        descriptions.add(element.description);
        containerColors.add(Color.fromARGB(element.colorAlpha!,
            element.colorRed!, element.colorGreen!, element.colorBlue!));
      }
    },
  );
}
