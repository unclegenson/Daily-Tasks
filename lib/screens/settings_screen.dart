import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_note_screen.dart';
import 'package:daily_tasks/screens/edit_profile_screens.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

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
        backgroundColor: Colors.black87,
        title: const MyAppBarTitle(
          fontSize: 46,
          title: 'Settings',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SettingsCategoryWidget(text: 'Profile Settings'),
            Settingbutton(
              size: size,
              icon: Icons.person,
              text: 'Edit Profile Data',
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const EditProfileScreen();
                    },
                  ),
                );
              },
            ),
            const Divider(
              thickness: 0.7,
              color: Colors.white70,
              indent: 20,
              endIndent: 20,
            ),
            const SettingsCategoryWidget(text: 'App Style'),
            Settingbutton(
              size: size,
              icon: Icons.color_lens_outlined,
              text: 'App theme',
              func: () {},
            ),
            Settingbutton(
              size: size,
              icon: Icons.font_download_rounded,
              text: 'Font',
              func: () {},
            ),
            Settingbutton(
              size: size,
              icon: Icons.text_rotate_up_outlined,
              text: 'Font size',
              func: () {},
            ),
            Settingbutton(
              size: size,
              icon: Icons.line_weight,
              text: 'Font Weight',
              func: () {},
            ),
            const Divider(
              thickness: 0.7,
              color: Colors.white70,
              indent: 20,
              endIndent: 20,
            ),
            const SettingsCategoryWidget(text: 'General Settings'),
            Settingbutton(
              size: size,
              text: reminder ? 'Reminder On' : 'Reminder Off',
              icon: reminder
                  ? Icons.toggle_on_outlined
                  : Icons.toggle_off_outlined,
              func: () {
                setState(() {
                  reminder = !reminder;
                });
              },
            ),
            Settingbutton(
              size: size,
              text: 'Show Date in tasks',
              func: () {},
              icon: Icons.edit_calendar_rounded,
            ),
            Settingbutton(
              icon: Icons.delete,
              size: size,
              text: 'Delete All Tasks',
              func: () {
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
                    Hive.box<Notes>('notesBox').deleteFromDisk();
                    Navigator.pop(context);
                  },
                  panaraDialogType: PanaraDialogType.error,
                  noImage: true,
                );
              },
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
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
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
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: func,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(
              width: 8,
            ),
            Icon(
              icon,
              size: 24,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
