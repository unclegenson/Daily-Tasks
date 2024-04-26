import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

String mahdiImg = 'assets/images/me.jpg';
String maryamImg = 'assets/images/maryam.jpg';
String mahdiName = 'Mohammad Mahdi';
String mahdiNumber = '+98 910 063 9128';
String maryamNumber = '+98 930 969 7796';
String maryamName = 'Maryam';

String showImg = mahdiImg;
String showName = mahdiName;
String showNumber = mahdiNumber;

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
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(showImg),
                        backgroundColor: Colors.black,
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
                          const Spacer(),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              setState(() {
                                if (isExpanded == true) {
                                  animeController.forward();
                                  isExpanded = !isExpanded;
                                } else {
                                  animeController.reverse();
                                  isExpanded = !isExpanded;
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white54,
                              child: AnimatedIcon(
                                progress: animeController,
                                icon: AnimatedIcons.menu_arrow,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      isExpanded
                          ? Column(
                              children: [
                                ListTile(
                                  visualDensity: const VisualDensity(
                                    horizontal: 0,
                                    vertical: -4,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  leading: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.black,
                                        backgroundImage: AssetImage(mahdiImg),
                                      ),
                                      !isSelected
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 24, top: 24),
                                              child: Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: Colors.purple,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  title: Text(mahdiName),
                                  selected: !isSelected,
                                  onTap: () {
                                    setState(() {
                                      isSelected = !isSelected;
                                      showName = mahdiName;
                                      showImg = mahdiImg;
                                      showNumber = mahdiNumber;
                                    });
                                  },
                                  selectedColor: Colors.purple,
                                  subtitle: Text(mahdiNumber),
                                ),
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      isSelected = !isSelected;
                                      showName = maryamName;
                                      showImg = maryamImg;
                                      showNumber = maryamNumber;
                                    });
                                  },
                                  selectedColor: Colors.purple,
                                  selected: isSelected,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  leading: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.black,
                                        backgroundImage: AssetImage(maryamImg),
                                      ),
                                      isSelected
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 24, top: 24),
                                              child: Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: Colors.purple,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  title: Text(maryamName),
                                  subtitle: Text(maryamNumber),
                                ),
                              ],
                            )
                          : const SizedBox()
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
              func: () {},
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
                      return SettingsScreen();
                    },
                  ),
                );
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
