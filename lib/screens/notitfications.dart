import 'package:bottom_picker/bottom_picker.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

int reminderHour = 23;
int reminderMin = 0;

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    getReminderTime();
    super.initState();
  }

  Future<void> getReminderTime() async {
    SharedPreferences prefDailyReminderHour =
        await SharedPreferences.getInstance();
    SharedPreferences prefDailyReminderMin =
        await SharedPreferences.getInstance();

    setState(() {
      reminderMin = prefDailyReminderMin.getInt('reminderMin')!;
      reminderHour = prefDailyReminderHour.getInt('reminderHour')!;
    });
  }

  Future<void> setReminderTime() async {
    SharedPreferences prefDailyReminderHour =
        await SharedPreferences.getInstance();
    SharedPreferences prefDailyReminderMin =
        await SharedPreferences.getInstance();

    prefDailyReminderMin.setInt('reminderMin', reminderMin);
    prefDailyReminderHour.setInt('reminderHour', reminderHour);
  }

  void openDateTimePicker(BuildContext context) {
    BottomPicker.time(
      initialTime: Time.now(),
      pickerTitle: Text(
        AppLocalizations.of(context)!.reminderTime,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Colors.blue,
        ),
      ),
      gradientColors: const [Colors.white, Colors.blue],
      backgroundColor: Colors.black87,
      closeIconColor: Colors.white,
      pickerTextStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      onSubmit: (p0) {
        setState(() {
          reminderHour = p0.hour;
          reminderMin = p0.minute;
        });
      },
    ).show(context);
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
            title: AppLocalizations.of(context)!.notificationSettings,
            fontSize: 42,
          ),
          titleSpacing: 10,
          elevation: 0,
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: size.height * 8 / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: SettingsCategoryWidget(
                      color: Colors.white,
                      text: AppLocalizations.of(context)!.chooseBestDaily,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width / 3,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        return openDateTimePicker(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.choose,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 5 / 10,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Row(
                      children: [
                        SettingsCategoryWidget(
                          color: Colors.white,
                          text: AppLocalizations.of(context)!
                              .yourBestDailyReminder,
                        ),
                        const Spacer(),
                        Text(
                          '${reminderHour.toString().length > 1 ? '$reminderHour' : '0$reminderHour'} : ${reminderMin.toString().length > 1 ? '$reminderMin' : '0$reminderMin'}',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: size.width - 40,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setReminderTime();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(//add this to localization
                                'Daily reminder set at ${reminderHour.toString().length > 1 ? '$reminderHour' : '0$reminderHour'} : ${reminderMin.toString().length > 1 ? '$reminderMin' : '0$reminderMin'}'),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
