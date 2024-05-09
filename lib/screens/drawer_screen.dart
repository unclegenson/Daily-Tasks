import 'dart:io';

import 'package:daily_tasks/screens/add_category_screen.dart';
import 'package:daily_tasks/screens/add_note_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

late AnimationController animeController;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    getProfile();
    animeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String showImg = '';
  String showName = '';
  String showNumber = '';

  getProfile() async {
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();

    setState(() {
      showImg = prefProfileImage.getString('profileImage')!;
      showName = prefProfileName.getString('profileName')!;
      showNumber = prefProfileNumber.getString('profileNumber')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      width: 300,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AnimatedContainer(
                curve: Curves.easeInOutCirc,
                duration: const Duration(milliseconds: 700),
                height: isExpanded ? 310 : 190,
                width: size.width * 2 / 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showName == ''
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: selectedColor,
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(File(showImg)),
                              backgroundColor: selectedColor,
                            ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                showName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                showNumber,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DrawerListTile(
              func: () {},
              text: 'Review',
              icon: Icons.bar_chart_rounded,
            ),
            DrawerListTile(
              func: () {},
              text: 'Go Premium',
              icon: Icons.workspace_premium,
            ),
            DrawerListTile(
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const AddCategoryScreen();
                    },
                  ),
                );
              },
              text: 'Add Category',
              icon: Icons.category_outlined,
            ),
            DrawerListTile(
              func: () {},
              text: 'Language',
              icon: Icons.language_rounded,
            ),
            DrawerListTile(
              text: 'Settings',
              icon: Icons.settings,
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingsScreen();
                    },
                  ),
                ).then((value) => getProfile());
              },
            ),
            const Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            DrawerListTile(
              text: 'Invite Friends',
              icon: Icons.person_add,
              func: () async {
                await Share.share('check out this app...');
              },
            ),
            DrawerListTile(
              text: 'Contact Us',
              icon: Icons.bubble_chart_rounded,
              func: () {
                _openUrl('mailto:unclegenson@gmail.com');
              },
            ),
          ],
        ),
      ),
    );
  }
}

bool isExpanded = false;
bool isSelected = false;

//todo vasl kardan contacts
//todo share app in invite friends