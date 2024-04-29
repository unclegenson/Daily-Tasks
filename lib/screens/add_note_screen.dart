import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../widgets/add_note_widget.dart';
import 'package:image_picker/image_picker.dart';

final List<String> items = [
  'Sport',
  'Book',
  'HomeWork',
  'Work',
  'Personal',
];

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

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, required this.note});
  final Notes note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

Color? selectedColor;
Color? _shadeColor = Colors.blue[800];
bool anythingToShow = false;

class _AddNoteScreenState extends State<AddNoteScreen> {
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white38,
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
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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

  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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

  @override
  void initState() {
    setState(() {
      if (widget.note.title == '') {
        setState(() {
          anythingToShow = false;
        });
      } else {
        setState(() {
          anythingToShow = true;
          mainTitleText = widget.note.title;
          mainDescriptionText = widget.note.description;
          selectedCategory = widget.note.category;
        });
      }
      selectedColor = anythingToShow
          ? Color.fromARGB(widget.note.colorAlpha!, widget.note.colorRed!,
              widget.note.colorGreen!, widget.note.colorBlue!)
          : colorItems[Random().nextInt(colorItems.length)];
    });
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
          title: MyAppBarTitle(
            title: anythingToShow ? 'Edit Task' : 'Add Task',
            fontSize: 46,
          ),
          titleSpacing: 10,
          elevation: 0,
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: size.width,
              height: size.height - 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TitleInputWidget(
                    size: size,
                    titleText: anythingToShow ? widget.note.title! : '',
                  ),
                  DropdownButtonFormField2(
                    style: const TextStyle(color: Colors.white),
                    isExpanded: true,
                    decoration: InputDecoration(
                      iconColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    hint: Text(
                      anythingToShow ? widget.note.category! : 'Category',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.white),
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
                  DescriptionInputWidget(
                    size: size,
                    descriptionText: widget.note.description!,
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
                              ? const Text('No Image selected')
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
                          mainDescriptionText == null ||
                          selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.fixed,
                            content: Text('Input data is empty!'),
                          ),
                        );
                      } else {
                        anythingToShow
                            ? await Hive.box<Notes>('notesBox').putAt(
                                int.parse(widget.note.id!),
                                Notes(
                                  // image: _image.toString(),
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
                              )
                            : await Hive.box<Notes>('notesBox').add(
                                Notes(
                                  // image: _image.toString(),
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
                        selectedCategory = null;
                        mainDescriptionText = null;
                        mainTitleText = null;
                        anythingToShow
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 1500),
                                  behavior: SnackBarBehavior.fixed,
                                  content: Text('Task Edited!'),
                                ),
                              )
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 1500),
                                  behavior: SnackBarBehavior.fixed,
                                  content: Text('Task Added!'),
                                ),
                              );
                        Navigator.pop(context);
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
