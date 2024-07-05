import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart' as h;
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/add_note_widget.dart';
import 'package:image_picker/image_picker.dart';

List categoryItems = [];

final recorder = FlutterSoundRecorder();
final audioPlayer = AudioPlayer();
bool isPlaying = false;
Duration durationOfAudio = Duration.zero;
Duration position = Duration.zero;
List colorItems = const [
  Color.fromARGB(255, 137, 207, 240),
  Color.fromARGB(255, 255, 229, 180),
  Color.fromARGB(255, 255, 209, 220),
  Color.fromARGB(255, 169, 211, 158),
  Color.fromARGB(255, 255, 200, 152),
  Color.fromARGB(255, 195, 177, 225),
  Color.fromARGB(255, 193, 187, 221),
  Color.fromARGB(255, 218, 191, 222),
  Color.fromARGB(255, 255, 220, 244),
  Color.fromARGB(255, 220, 255, 251),
  Color.fromARGB(255, 193, 231, 227),
];

String? selectedCategory;
bool micOn = false;
bool isRecording = false;

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, required this.note});
  final Notes note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

Color? selectedColor;
Color? _shadeColor = Colors.blue[800];
bool anythingToShow = false;
String? pathOfVoice;

class _AddNoteScreenState extends State<AddNoteScreen> {
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white54,
          contentPadding: const EdgeInsets.all(18.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'SUBMIT',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future showOptions() async {
    SharedPreferences premium = await SharedPreferences.getInstance();
    if (premium.getBool('purchase')!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are not a Premium contact yet!',
          ),
          duration: Duration(milliseconds: 2500),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedColor,
                ),
                child: const Text(
                  'Photo Gallery',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // close the options modal
                  Navigator.of(context).pop();
                  // get image from gallery
                  getImageFromGallery();
                },
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedColor,
                ),
                child: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // close the options modal
                  Navigator.of(context).pop();
                  // get image from camera
                  getImageFromCamera();
                },
              ),
            ],
          );
        },
      );
    }
  }

  File? _image;
  String? imageString;
  final picker = ImagePicker();
  String? voiceString;
  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageString = pickedFile.path;
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // for showing image
        imageString = pickedFile.path; // for hive
      }
    });
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => selectedColor = color),
      ),
    );
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    await recorder.openRecorder();
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future setAudio() async {
    audioPlayer.setSourceDeviceFile(pathOfVoice!);
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen(
      (event) {
        setState(() {
          isPlaying = event == h.PlayerState.isPlaying;
        });
      },
    );
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        durationOfAudio = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    initRecorder();

    setState(() {
      categoryItems.clear();

      Hive.box<Categories>('categoryBox').values.forEach((element) {
        categoryItems.add(element.name);
      });
      if (widget.note.title == '') {
        setState(() {
          anythingToShow = false;
          pathOfVoice = widget.note.voice;
        });
      } else {
        setState(() {
          anythingToShow = true;
          mainTitleText = widget.note.title;
          mainDescriptionText = widget.note.description;
          selectedCategory = widget.note.category;
          if (widget.note.image != null) {
            _image = File(widget.note.image!);
          }
        });
      }
      selectedColor = anythingToShow
          ? Color.fromARGB(widget.note.colorAlpha!, widget.note.colorRed!,
              widget.note.colorGreen!, widget.note.colorBlue!)
          : colorItems[Random().nextInt(colorItems.length)];
    });
    super.initState();
  }

  Future record() async {
    SharedPreferences audioId = await SharedPreferences.getInstance();
    audioId.setInt('audio', audioId.getInt('audio')! + 1);
    await recorder.startRecorder(
        toFile: 'audio${audioId.getInt('audio')}', codec: Codec.defaultCodec);
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    setState(() {
      pathOfVoice = path;
      voiceString = pathOfVoice;
    });
    audioPlayer.setSourceDeviceFile(pathOfVoice!);
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
          title: MyAppBarTitle(
            title: anythingToShow ? 'Edit Task' : 'Add Task',
            fontSize: 46,
          ),
          titleSpacing: 10,
          elevation: 0,
          toolbarHeight: 70,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences premium =
                          await SharedPreferences.getInstance();
                      if (premium.getBool('purchase')!) {
                        //todo: ! here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You are not a Premium contact yet!',
                            ),
                            duration: Duration(milliseconds: 2500),
                          ),
                        );
                      } else {
                        if (micOn == true) {
                          setState(() {
                            micOn = false;
                          });
                        } else {
                          setState(() {
                            micOn = true;
                          });
                        }
                      }
                    },
                    child: Icon(
                      !micOn ? Icons.mic : Icons.mic_off_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: size.width,
              height: size.height - 130, //todo: fix this 130
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  micOn == false
                      ? Column(
                          children: [
                            TitleInputWidget(
                              size: size,
                              titleText:
                                  anythingToShow ? widget.note.title! : '',
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            DropdownButtonFormField2(
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              decoration: InputDecoration(
                                iconColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              hint: Text(
                                anythingToShow
                                    ? widget.note.category!
                                    : ' Category',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              items: categoryItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value.toString();
                                });
                              },
                              onSaved: (value) {},
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            DescriptionInputWidget(
                              size: size,
                              descriptionText: widget.note.description!,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              isRecording
                                  ? 'Recording...'
                                  : 'Click the button to start reording...',
                              style: TextStyle(color: selectedColor),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            StreamBuilder(
                              stream: recorder.onProgress,
                              builder: (context, snapshot) {
                                final duration = snapshot.hasData
                                    ? snapshot.data!.duration
                                    : Duration.zero;

                                String twoDigits(int n) =>
                                    n.toString().padLeft(2);
                                final twoDigitMinutes =
                                    twoDigits(duration.inMinutes.remainder(60));
                                final twoDigitSecons =
                                    twoDigits(duration.inSeconds.remainder(60));

                                return Text(
                                  '$twoDigitMinutes :$twoDigitSecons',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 26),
                                );
                              },
                            ),
                            Slider(
                              activeColor: selectedColor,
                              divisions: 20,
                              value: position.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await audioPlayer.seek(position);
                              },
                              min: 0,
                              max: durationOfAudio.inSeconds.toDouble(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    position.inSeconds.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    durationOfAudio.inSeconds.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (recorder.isRecording) {
                                      await stop();
                                      setState(() {
                                        isRecording = false;
                                      });
                                    } else {
                                      await record();
                                      setState(() {
                                        isRecording = true;
                                      });
                                    }
                                  },
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: !isRecording
                                          ? const Icon(
                                              Icons.mic,
                                              color: Colors.black,
                                            )
                                          : const Icon(
                                              Icons.square,
                                              color: Colors.black,
                                            ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setAudio();
                                    audioPlayer.resume();
                                  },
                                  icon: Container(
                                    decoration: const BoxDecoration(
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
                                IconButton(
                                  onPressed: () {
                                    audioPlayer.pause();
                                  },
                                  icon: Container(
                                    decoration: const BoxDecoration(
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
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            TitleInputWidget(
                              size: size,
                              titleText:
                                  anythingToShow ? widget.note.title! : '',
                            ),
                          ],
                        ),
                  GestureDetector(
                    onTap: () {
                      showOptions();
                    },
                    child: Container(
                      height: 160,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70, width: 0.4),
                      ),
                      child: Stack(
                        children: [
                          _image == null
                              ? const SizedBox()
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Image.file(
                                        _image!,
                                      ),
                                    ),
                                  ),
                                ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18, top: 18),
                            child: Text(
                              'Attach an image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openColorPicker,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1500),
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: size.width / 2 - 20,
                          height: 100,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pick a Color',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.imagesearch_roller_rounded,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      CalenderWidget(size: size),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (mainTitleText == null ||
                          mainDescriptionText == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.fixed,
                            content: Text('Input data is empty!'),
                          ),
                        );
                      } else {
                        if (anythingToShow) {
                          await Hive.box<Notes>('notesBox').putAt(
                            int.parse(widget.note.id!),
                            Notes(
                              voice: voiceString,
                              image: imageString,
                              category: selectedCategory,
                              colorAlpha: selectedColor?.alpha,
                              colorRed: selectedColor?.red,
                              colorBlue: selectedColor?.blue,
                              colorGreen: selectedColor?.green,
                              day: time.day,
                              description: mainDescriptionText,
                              done: false,
                              hour: time.hour,
                              id: time.toString(),
                              minute: time.minute,
                              month: time.month,
                              title: mainTitleText,
                              weekDay: time.weekday,
                              year: time.year,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.fixed,
                              content: Text('Task Edited!'),
                            ),
                          );
                        } else {
                          await Hive.box<Notes>('notesBox').add(
                            Notes(
                              voice: voiceString,
                              image: imageString,
                              category: selectedCategory,
                              colorAlpha: selectedColor?.alpha,
                              colorRed: selectedColor?.red,
                              colorBlue: selectedColor?.blue,
                              colorGreen: selectedColor?.green,
                              day: time.day,
                              description: mainDescriptionText,
                              done: false,
                              hour: time.hour,
                              id: time.toString(),
                              minute: time.minute,
                              month: time.month,
                              title: mainTitleText,
                              weekDay: time.weekday,
                              year: time.year,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.fixed,
                              content: Text('Task Added!'),
                            ),
                          );
                          if (imageString != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 2500),
                                behavior: SnackBarBehavior.fixed,
                                content: Text(
                                    'Long press on each Note to see each image'),
                              ),
                            );
                          }
                        }

                        Navigator.pop(context);
                        //!send notif here ->
                        AwesomeNotifications().createNotification(
                          schedule: NotificationCalendar(
                            day: time.day,
                            hour: time.hour,
                            minute: time.minute - 1,
                            month: time.month,
                            year: time.year,
                          ),
                          content: NotificationContent(
                            category: NotificationCategory.Reminder,
                            wakeUpScreen: true,
                            color: selectedColor,
                            id: 10,
                            channelKey: 'chanel',
                            title: 'Daily Tasks',
                            body: 'time of $mainTitleText is now!',
                          ),
                        );
                        //! -------------------
                        selectedCategory = null;
                        mainDescriptionText = null;
                        mainTitleText = null;
                        voiceString = '';
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: selectedColor,
                      ),
                      width: size.width - 30,
                      height: 60,
                      child: Center(
                        child: Text(
                          anythingToShow ? 'Edit Task' : 'Create Task',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//ezafe kardan be hive
//purchase check