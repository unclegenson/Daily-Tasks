import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks/models/models.dart';
import 'screens/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox<Notes>('notesBox');
  await Hive.openBox<Categories>('categoryBox');
  await Hive.openBox<ProfileData>('profileBox');

  runApp(const App());
}

List<Box> boxList = [];

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'tasks',
        home: HomeScreen(),
      ),
    );
  }
}

//todo: add image to db and show it at top right of eaach note
// todo: fix search 
// todo: start drawer items
//todo: add link app
