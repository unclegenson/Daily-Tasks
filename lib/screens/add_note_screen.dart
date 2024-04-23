import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:daily_tasks/models/notes.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../widgets/add_note_widget.dart';

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
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

Color? themeColor;
Color? selectedColor;
Color? _shadeColor = Colors.blue[800];

class _AddNoteScreenState extends State<AddNoteScreen> {
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white70,
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
      selectedColor = colorItems[Random().nextInt(colorItems.length)];
      themeColor = selectedColor;
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              //todo: svg arrow back button
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black87,
          title: const MyAppBarTitle(
            title: 'Add Task',
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
                  TitleInputWidget(size: size),
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
                    hint: const Text(
                      'Category',
                      style: TextStyle(
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
                  DescriptionInputWidget(size: size),
                  GestureDetector(
                    onTap: () {
                      //todo: connect to gallery for choosing photo
                    },
                    child: Container(
                      height: 160,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70, width: 0.4),
                      ),
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Text(
                                'Attach an image',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.attach_file_outlined,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      if (titleText != null && descriptionText != null) {
                        await Hive.box<Notes>('notesBox').add(
                          Notes(
                            category: selectedCategory,
                            colorAlpha: selectedColor?.alpha,
                            colorRed: selectedColor?.red,
                            colorBlue: selectedColor?.blue,
                            colorGreen: selectedColor?.green,
                            day: time.day,
                            description: descriptionText,
                            done: false,
                            hour: time.hour,
                            id: time.toString(),
                            minute: time.minute,
                            month: time.month,
                            title: titleText,
                            weekDay: time.weekday,
                            year: time.year,
                          ),
                        );
                        selectedCategory = null;
                        descriptionText = null;
                        titleText = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.fixed,
                            content: Text('Note Added!'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.fixed,
                            content: Text('Input data has problems!'),
                          ),
                        );
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
                      child: const Center(
                        child: Text(
                          'Create Task',
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
