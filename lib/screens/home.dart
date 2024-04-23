import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks/models/notes.dart';
import 'package:daily_tasks/screens/add_note_screen.dart';
import 'package:daily_tasks/screens/drawer_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../widgets/app_widgets.dart';

bool showSearchBar = false;
List weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Tur', 'Fri'];
List texts = [];
List descriptions = [];
List dateTimes = [];
List containerColors = [];
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
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/svgham.svg',
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
                                      texts.clear();
                                      descriptions.clear();
                                      dateTimes.clear();
                                      containerColors.clear();
                                      Hive.box<Notes>('notesBox')
                                          .values
                                          .forEach(
                                        (element) {
                                          dateTimes.add({
                                            'day': element.day,
                                            'weekDay': element.weekDay,
                                            'mounth': element.month,
                                            'year': element.year
                                          });
                                          texts.add(element.title);
                                          containerColors.add(
                                            Color.fromARGB(
                                              element.colorAlpha!,
                                              element.colorRed!,
                                              element.colorGreen!,
                                              element.colorBlue!,
                                            ),
                                          );
                                          descriptions.add(element.description);
                                        },
                                      );

                                      setState(() {
                                        texts = texts.where((element) {
                                          return element
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                                  .toString()
                                                  .toLowerCase());
                                        }).toList();
                                      });
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
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_task_sharp,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        'Add a note!',
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
                                    PanaraConfirmDialog.showAnimatedGrow(
                                      context,
                                      title: "Delete this note?",
                                      message:
                                          "Are you sure you want to delete this note?",
                                      confirmButtonText: "Yes",
                                      cancelButtonText: "No",
                                      onTapCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onTapConfirm: () {
                                        Hive.box<Notes>('notesBox')
                                            .deleteAt(index);
                                        textsListCreate();
                                        done = false;
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      panaraDialogType:
                                          PanaraDialogType.warning,
                                      noImage: true,
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
                                              maxLines: 2,
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
                                              maxLines:
                                                  constraints.maxHeight > 200
                                                      ? 8
                                                      : 3,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, bottom: 0),
                                          child: Row(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: size.width / 5,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            Colors.teal,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            12,
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
                                                                .deleteAt(
                                                                    index);
                                                            textsListCreate();
                                                            done = false;
                                                            setState(() {});
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
                                                          : const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Done',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Icon(
                                                                    Icons.check,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .white)
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Text(
                                                  '${weekDays[dateTimes[index]['weekDay']]} - ${dateTimes[index]['day'].toString()}',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const AddNoteScreen();
            },
          ),
        ).then((value) {
          textsListCreate();
          setState(() {});
        });
      },
      backgroundColor: Colors.grey[800],
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void textsListCreate() {
    descriptions.clear();
    texts.clear();
    dateTimes.clear();
    containerColors.clear();
    Hive.box<Notes>('notesBox').values.forEach((element) {
      dateTimes.add({
        'day': element.day,
        'weekDay': element.weekDay,
        'mounth': element.month,
        'year': element.year
      });
      texts.add(element.title);
      descriptions.add(element.description);
      containerColors.add(Color.fromARGB(element.colorAlpha!, element.colorRed!,
          element.colorGreen!, element.colorBlue!));
    });
  }
}
