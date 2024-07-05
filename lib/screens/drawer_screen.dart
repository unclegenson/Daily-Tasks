import 'dart:io';

import 'package:daily_tasks/screens/add_birthday_screen.dart';
import 'package:daily_tasks/screens/add_category_screen.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/go_premium_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarinpal/zarinpal.dart';
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
                          const SizedBox(
                            width: 0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    showName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  purchase
                                      ? const Icon(
                                          Icons.workspace_premium,
                                          color: Colors.deepOrangeAccent,
                                        )
                                      : const SizedBox(),
                                ],
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
              text: 'Premium V.',
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
              text: 'Add Category',
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
                    const SnackBar(
                      behavior: SnackBarBehavior.fixed,
                      duration: Duration(
                        milliseconds: 2500,
                      ),
                      content: Text('You are not a permium contact'),
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
              text: 'Add Birthday',
              icon: Icons.cake_sharp,
            ),
            DrawerListTile(
              func: () {
                PaymentRequest _paymentRequest = PaymentRequest();

                _paymentRequest.setIsSandBox(true);
                _paymentRequest.setMerchantID("Zarinpal MerchantID");
                _paymentRequest.setAmount(69000); //integar Amount
                _paymentRequest.setCallbackURL("return://myZarinPal");
                _paymentRequest.setDescription("Daily Tasks Premium Version");

                String? _paymentUrl;

                ZarinPal().startPayment(_paymentRequest,
                    (int? status, String? paymentGatewayUri) async {
                  print(paymentGatewayUri);
                  if (status == 100) {
                    if (!await launchUrl(Uri.parse(paymentGatewayUri!))) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('error while routing to zarin pal'),
                        ),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('some error is happened'),
                      ),
                    );
                  }
                });

                ZarinPal().verificationPayment(
                    "Status", "Authority Call back", _paymentRequest,
                    (isPaymentSuccess, refID, paymentRequest) {
                  if (isPaymentSuccess) {
                    // Payment Is Success
                    print("Success");
                  } else {
                    // Error Print Status
                    print("Error");
                  }
                });
              },
              text: 'Buy me a coffee',
              icon: Icons.coffee_rounded,
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

//todo vasl kardan contacts
