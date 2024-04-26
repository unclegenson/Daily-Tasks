import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_note_screen.dart';
import 'package:daily_tasks/screens/drawer_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../widgets/app_widgets.dart';

bool showSearchBar = false;
List weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Tur', 'Fri'];
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    textsListCreate();
    super.initState();
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
            leading: Builder(builder: (context) {
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
            }),
            elevation: 0,
            toolbarHeight: 70,
            backgroundColor: Colors.black87,
            title: const MyAppBarTitle(
              title: 'Daily Tasks',
              fontSize: 46,
            ),
            actions: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AnimatedSize(
                    alignment: Alignment.centerLeft,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInBack,
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showSearchBar = !showSearchBar;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[800],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: SvgPicture.asset(
                                  'assets/svgsearch.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcATop),
                                ),
                              ),
                            ),
                          ),
                          showSearchBar
                              ? SizedBox(
                                  width: size.width * 7 / 10,
                                  child: TextField(
                                    onChanged: (value) {
                                      // texts.clear();
                                      // descriptions.clear();
                                      // dateTimes.clear();
                                      // categories.clear();
                                      // containerColors.clear();
                                      // searchItemIndexes.clear();
                                      // Hive.box<Notes>('notesBox')
                                      //     .values
                                      //     .forEach(
                                      //   (element) {
                                      //     dateTimes.add({
                                      //       'day': element.day,
                                      //       'weekDay': element.weekDay,
                                      //       'mounth': element.month,
                                      //       'year': element.year
                                      //     });
                                      //     copyOfDateTimes = dateTimes;
                                      //     print(copyOfDateTimes);

                                      //     texts.add(element.title);
                                      //     copyOfTexts = texts;

                                      //     categories.add(element.category);
                                      //     copyOfCategories = categories;

                                      //     containerColors.add(
                                      //       Color.fromARGB(
                                      //         element.colorAlpha!,
                                      //         element.colorRed!,
                                      //         element.colorGreen!,
                                      //         element.colorBlue!,
                                      //       ),
                                      //     );
                                      //     copyOfContainerColors =
                                      //         containerColors;

                                      //     descriptions.add(element.description);
                                      //     copyOfDescriptions = descriptions;
                                      //     print(copyOfDescriptions);
                                      //   },
                                      // );
                                      // setState(() {
                                      //   texts = texts.where((element) {
                                      //     return element
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(
                                      //           value.toString().toLowerCase(),
                                      //         );
                                      //   }).toList();
                                      //   descriptions.clear();
                                      //   dateTimes.clear();
                                      //   categories.clear();
                                      //   containerColors.clear();
                                      //   for (var element in texts) {
                                      //     searchItemIndexes.add(
                                      //         copyOfTexts.indexOf(element));
                                      //   }

                                      //   for (var index in searchItemIndexes) {
                                      //     descriptions
                                      //         .add(copyOfDescriptions[index]);
                                      //     dateTimes.add(copyOfDateTimes[index]);
                                      //     containerColors.add(
                                      //         copyOfContainerColors[index]);
                                      //     categories
                                      //         .add(copyOfCategories[index]);
                                      //   }
                                      // });
                                    },
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AddNoteScreen(
                                            note: Notes(
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
                                              minute: dateTimes[index]
                                                  ['minute'],
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: containerColors[index],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 10,
                                            top: 10,
                                          ),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              texts[index],
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 10),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              descriptions[index],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black54,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                                                    containerColors[
                                                                            index]
                                                                        .alpha,
                                                                colorBlue:
                                                                    containerColors[
                                                                            index]
                                                                        .blue,
                                                                colorGreen:
                                                                    containerColors[
                                                                            index]
                                                                        .green,
                                                                colorRed:
                                                                    containerColors[
                                                                            index]
                                                                        .red,
                                                                day: dateTimes[
                                                                        index]
                                                                    ['day'],
                                                                hour: dateTimes[
                                                                        index]
                                                                    ['hour'],
                                                                minute: dateTimes[
                                                                        index]
                                                                    ['minute'],
                                                                month: dateTimes[
                                                                        index]
                                                                    ['mount'],
                                                                weekDay: dateTimes[
                                                                        index]
                                                                    ['weekDay'],
                                                                year: dateTimes[
                                                                        index]
                                                                    ['year'],
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
                                                                color: colorItems[
                                                                    index %
                                                                        colorItems
                                                                            .length],
                                                                strokeWidth: 1,
                                                              ),
                                                            )
                                                          : const Icon(
                                                              Icons.check,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size.width / 10,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Colors.red,
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
                                                                  setState(() {
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
                                                                  setState(() {
                                                                    done =
                                                                        false;
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
                                                                      color: colorItems[
                                                                          index %
                                                                              colorItems.length],
                                                                      strokeWidth:
                                                                          1,
                                                                    ),
                                                                  )
                                                                : const Icon(
                                                                    Icons.close,
                                                                    size: 20,
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
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                '${weekDays[dateTimes[index]['weekDay']]} - ${dateTimes[index]['day'].toString()}',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
          )),
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
                    category: '',
                    colorAlpha: 0,
                    day: 0,
                    description: '',
                    done: done,
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
        child: SizedBox(
          height: 35,
          width: 35,
          child: SvgPicture.asset(
            'assets/edit2.svg',
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcATop),
          ),
        ),
      ),
    );
  }

  void textsListCreate() {
    descriptions.clear();
    texts.clear();
    dateTimes.clear();
    categories.clear();
    containerColors.clear();
    Hive.box<Notes>('notesBox').values.forEach(
      (element) {
        if (!element.done!) {
          dateTimes.add({
            'day': element.day,
            'weekDay': element.weekDay,
            'mounth': element.month,
            'year': element.year
          });
          texts.add(element.title);
          categories.add(element.category);
          descriptions.add(element.description);
          containerColors.add(Color.fromARGB(element.colorAlpha!,
              element.colorRed!, element.colorGreen!, element.colorBlue!));
        }
      },
    );
  }
}


// descriptions : desc 332 , desc , desc 5
// texts : title 7 , title 1 , title 5
// copy of texts :  title 7 , title 1 , title 5


// texts : title 7 , title 5
// indexes : 0 , 2
// descriptions : desc 332 , desc 5





