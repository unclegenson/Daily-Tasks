import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/edit_profile_screens.dart';
import 'package:daily_tasks/screens/language_screen.dart';
import 'package:daily_tasks/screens/notitfications.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

bool purchase = false;

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
        title: MyAppBarTitle(
          fontSize: 46,
          title: AppLocalizations.of(context)!.settings,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: size.height / 2 - 70,
          ),
          itemBuilder: (_, index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const EditProfileScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.indigo[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (index == 1) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NotificationsScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_active_rounded,
                          size: 45,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.notifications,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (index == 2) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LanguageScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.language,
                          size: 45,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (index == 3) {
              return GestureDetector(
                onTap: () {
                  PanaraConfirmDialog.showAnimatedGrow(
                    context,
                    title: AppLocalizations.of(context)!.deleteAllTasks,
                    message: AppLocalizations.of(context)!.pressDeleteIf,
                    confirmButtonText: AppLocalizations.of(context)!.delete,
                    cancelButtonText: AppLocalizations.of(context)!.cancel,
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
                child: Container(
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete,
                          size: 45,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.deleteAllTasks,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return null;
          },
          itemCount: 4,
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
