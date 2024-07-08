import 'package:daily_tasks/main.dart';
import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/edit_profile_screens.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

bool purchase = false;
bool reminder = false;

class _SettingsScreenState extends State<SettingsScreen> {
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
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const MyAppBarTitle(
          fontSize: 46,
          title: 'Settings',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditProfileScreen(
                        image: profileImage,
                        name: profileName,
                        number: profileNumber,
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: size.height / 7,
                width: size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedColor,
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences isPerchased =
                    await SharedPreferences.getInstance();
                purchase = isPerchased.getBool('purchase')!;

                setState(() {
                  if (purchase == true) {
                    reminder = !reminder;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.fixed,
                        duration: Duration(
                          milliseconds: 2500,
                        ),
                        content: Text('You are not a permium contact'),
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: size.height / 7,
                width: size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedColor,
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(
                        Icons.notifications_active,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: size.height / 7,
                width: size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: size.height / 7,
                width: size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                PanaraConfirmDialog.showAnimatedGrow(
                  context,
                  title: "Delete All?",
                  message:
                      "Press Delete if you want to delete all the available tasks.",
                  confirmButtonText: "Delete",
                  cancelButtonText: "Cancel",
                  onTapCancel: () {
                    Navigator.pop(context);
                  },
                  onTapConfirm: () {
                    if (Hive.box<Notes>('notesBox').length > 0) {
                      Hive.box<Notes>('notesBox').deleteFromDisk().then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please Close and reOpen the app for better performance'),
                            ),
                          );
                        },
                      );
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nothing to delete :|'),
                        ),
                      );
                    }
                  },
                  panaraDialogType: PanaraDialogType.error,
                  noImage: true,
                );
              },
              child: Container(
                height: size.height / 7,
                width: size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedColor,
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(
                        Icons.delete,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delete All Tasks',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCategoryWidget extends StatelessWidget {
  const SettingsCategoryWidget({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class Settingbutton extends StatelessWidget {
  const Settingbutton({
    super.key,
    required this.size,
    required this.text,
    required this.func,
    required this.icon,
  });

  final String text;
  final void Function()? func;
  final Size size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: 45,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        onTap: func,
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        leading: Icon(icon, size: 22, color: Colors.white),
      ),
    );
  }
}
