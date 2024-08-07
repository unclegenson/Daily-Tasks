import 'dart:io';

import 'package:daily_tasks/screens/add_birthday_screen.dart';
import 'package:daily_tasks/screens/add_category_screen.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/go_premium_screen.dart';
import 'package:daily_tasks/screens/review_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    super.initState();
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
  bool purchase = false;

  getProfile() async {
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();
    SharedPreferences isPerchased = await SharedPreferences.getInstance();
    purchase = isPerchased.getBool('purchase')!;

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    showName,
                                    style: const TextStyle(
                                      fontFamily: 'title',
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  purchase
                                      ? Icon(
                                          Icons.workspace_premium,
                                          color: Colors.green[700],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              Text(
                                showNumber,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'title',
                                  fontSize: 22,
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
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ReviewScreen();
                    },
                  ),
                );
              },
              text: AppLocalizations.of(context)!.review,
              icon: Icons.bar_chart_rounded,
            ),
            DrawerListTile(
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const GoPremmium();
                    },
                  ),
                );
              },
              text: AppLocalizations.of(context)!.premiumV,
              icon: Icons.beach_access_rounded,
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
              text: AppLocalizations.of(context)!.addCategory,
              icon: Icons.category_outlined,
            ),
            DrawerListTile(
              func: () async {
                SharedPreferences isPerchased =
                    await SharedPreferences.getInstance();
                purchase = isPerchased.getBool('purchase')!;
                if (!purchase == false) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.fixed,
                      duration: const Duration(
                        milliseconds: 2500,
                      ),
                      content: Text(AppLocalizations.of(context)!
                          .youAreNotAPremiumContact),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AddBirthday();
                      },
                    ),
                  );
                }
              },
              text: AppLocalizations.of(context)!.addBirthdayDate,
              icon: Icons.cake_sharp,
            ),
            DrawerListTile(
              func: () {},
              text: AppLocalizations.of(context)!.buyMeACoffee,
              icon: Icons.coffee_rounded,
            ),
            DrawerListTile(
              text: AppLocalizations.of(context)!.settings,
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
              text: AppLocalizations.of(context)!.inviteFriends,
              icon: Icons.person_add,
              func: () async {
                await Share.share(
                    AppLocalizations.of(context)!.checkOutThisApp);
              },
            ),
            DrawerListTile(
              text: AppLocalizations.of(context)!.contactUs,
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

//todo vasl kardan contacts
