import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class AddBirthday extends StatefulWidget {
  const AddBirthday({super.key});

  @override
  State<AddBirthday> createState() => _AddBirthdayState();
}

Color? selectedColor2;

List birthDayList = [];
List nameList = [];
List numberList = [];
bool showTime = false;
DateTime time = DateTime.now();

bool wantToChange = false;
TextEditingController nameCon = TextEditingController();
DateTime newBirthdayDate = DateTime.now();
String? newName;
String? newPhone;
int indexx = 0;
TextEditingController numberCon = TextEditingController();

class _AddBirthdayState extends State<AddBirthday> {
  @override
  void initState() {
    selectedColor2 = colorItems[Random().nextInt(colorItems.length)];
    wantToChange = false;
    nameCon.clear();
    numberCon.clear();

    newName = '';
    newPhone = '';

    birthDayList.clear();

    Hive.box<Birthdays>('birthdayBox').values.forEach((element) {
      nameList.add(element.name);
      numberList.add(element.number);
      birthDayList.add(element.date);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        toolbarHeight: 70,
        leading: Builder(
          builder: (context) {
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
          },
        ),
        backgroundColor: Colors.black87,
        title: const MyAppBarTitle(
          fontSize: 46,
          title: 'Birthday List',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: size.height * 8.2 / 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 4.5 / 10,
                  child: ListView.builder(
                    itemCount: nameList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 8),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              wantToChange = true;
                              indexx = index;

                              newName = nameList[index];
                              nameCon.text = newName!;

                              newPhone = numberList[index];
                              numberCon.text = newPhone!;

                              newBirthdayDate = birthDayList[index];
                              time = newBirthdayDate;
                            });
                          },
                        ),
                        title: Text(
                          nameList[index],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(birthDayList[index].toString()),
                        leading: const Icon(Icons.circle),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SettingsCategoryWidget(
                      color: Colors.white,
                      text: !wantToChange ? 'Add Name :' : 'Edit Name :'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                  child: TextFormField(
                    controller: nameCon,
                    onChanged: (value) {
                      setState(() {
                        newName = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SettingsCategoryWidget(
                    color: Colors.white,
                    text: !wantToChange
                        ? 'Add Birthday date :'
                        : 'Edit birthday date :',
                  ),
                ),
                const CalenderWidgetBirthday(),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SettingsCategoryWidget(
                    color: Colors.white,
                    text: !wantToChange
                        ? 'Add Phone Number :'
                        : 'Edit Phone Number :',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                  child: TextFormField(
                    controller: numberCon,
                    onChanged: (value) {
                      setState(() {
                        newPhone = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (wantToChange) {
                        if (newName != '') {
                          setState(() {
                            nameList.add(newName);
                            numberList.add(newPhone);
                            birthDayList.add(newBirthdayDate);
                            nameList.removeAt(indexx);
                            numberList.removeAt(indexx);
                            birthDayList.removeAt(indexx);
                          });
                          Hive.box<Birthdays>('birthdayBox').putAt(
                            indexx,
                            Birthdays(
                              name: newName,
                              number: newPhone,
                              date: newBirthdayDate,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit the birthday items please!',
                              ),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        }
                      } else {
                        if (newName != '') {
                          setState(() {
                            nameList.add(newName);
                            numberList.add(newPhone);
                            birthDayList.add(newBirthdayDate);
                          });
                          Hive.box<Birthdays>('birthdayBox').add(
                            Birthdays(
                              name: newName,
                              number: newPhone,
                              date: newBirthdayDate,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Nothing added!',
                              ),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalenderWidgetBirthday extends StatefulWidget {
  const CalenderWidgetBirthday({super.key});

  @override
  State<CalenderWidgetBirthday> createState() => _CalenderWidgetBirthdayState();
}

class _CalenderWidgetBirthdayState extends State<CalenderWidgetBirthday> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void openDateTimePicker2(BuildContext context) {
      BottomPicker.date(
        pickerTitle: Text(
          'Choose Note Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: selectedColor,
          ),
        ),
        gradientColors: [selectedColor2!, Colors.blue],
        backgroundColor: Colors.black87,
        closeIconColor: selectedColor2!,
        initialDateTime: DateTime(DateTime.now().year),
        maxDateTime: DateTime(DateTime.now().year),
        minDateTime: DateTime(1900),
        pickerTextStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        onChange: (p0) {
          setState(() {
            time = p0;
          });
        },
      ).show(context);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: size.width - 56,
      height: 50,
      child: InkWell(
        onTap: () {
          return openDateTimePicker2(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${time.day.toString()} - ${time.month.toString()} - ${time.year.toString()}',
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const Divider(
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
