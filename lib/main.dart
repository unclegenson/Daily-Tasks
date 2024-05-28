import 'package:daily_tasks/models/notification_model.dart';
import 'package:daily_tasks/screens/edit_profile_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks/models/models.dart';
import 'screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

String profileImage = '';
String profileName = '';
String profileNumber = '';

void main() async {
  await AwesomeNotifications().initialize(
    debug: true,
    null,
    [
      NotificationChannel(
        channelKey: 'chanel',
        channelName: 'notif name',
        channelDescription: 'daily tasks notif',
        channelGroupKey: 'basic_chanel_group',
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_chanel_group',
        channelGroupName: 'basic group',
      )
    ],
  );

  bool isAllowToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (isAllowToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(BirthdaysAdapter());

  await Hive.openBox<Notes>('notesBox');
  await Hive.openBox<Categories>('categoryBox');
  await Hive.openBox<Birthdays>('birthdayBox');

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  checkEnterForFirstTime() async {
    SharedPreferences isActivePref = await SharedPreferences.getInstance();
    if (isActivePref.getBool('isActive') == null) {
      setProfileData();
      // scheduleDailyNotification();
    } else {
      getProfile();
    }
  }

  @override
  void initState() {
    checkEnterForFirstTime();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      //todo: open the birthday screen to type a text message to whom want to message
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );
    super.initState();
  }

  getProfile() async {
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();

    setState(() {
      profileImage = prefProfileImage.getString('profileImage')!;
      profileName = prefProfileName.getString('profileName')!;
      profileNumber = prefProfileNumber.getString('profileNumber')!;
    });
  }

  setProfileData() async {
    SharedPreferences isActivePref = await SharedPreferences.getInstance();
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();

    await isActivePref.setBool('isActive', false);
    await prefProfileNumber.setString('profileNumber', profileNumber);
    await prefProfileName.setString('profileName', profileName);
    await prefProfileImage.setString('profileImage', profileImage);
  }

  Future<bool> isActive() async {
    SharedPreferences isActivePref = await SharedPreferences.getInstance();
    return isActivePref.getBool('isActive') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Tasks',
        home: FutureBuilder(
          future: isActive(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const EditProfileScreen(image: '', name: '', number: '');
            }
          },
        ),
      ),
    );
  }
}

//todo: add image to db and show it at top right of eaach note
// todo: fix search 
// todo: start drawer items
//todo: add link app
