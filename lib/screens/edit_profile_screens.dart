import 'dart:io';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/home.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.number});
  final String image;
  final String name;
  final String number;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

String imageController = '';
String nameController = '';
String numberController = '';
bool checkFirstEntry = true;

class _EditProfileScreenState extends State<EditProfileScreen> {
  checkEnterForFirstTime() async {
    SharedPreferences isActivePref = await SharedPreferences.getInstance();
    if (isActivePref.getBool('isActive') == null) {
      setProfileData();
      SharedPreferences premium = await SharedPreferences.getInstance();
      premium.setBool('purchase', false);
      // scheduleDailyNotification();
    } else {
      checkFirstEntry = false;
      loadProfileData();
    }
  }

  @override
  void initState() {
    checkEnterForFirstTime();
    super.initState();
  }

  loadProfileData() async {
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();

    setState(() {
      nameController = prefProfileName.getString('profileName')!;
      numberController = prefProfileNumber.getString('profileNumber')!;
      imageController = prefProfileImage.getString('profileImage')!;
    });
  }

  setProfileData() async {
    SharedPreferences isActivePref = await SharedPreferences.getInstance();
    SharedPreferences prefProfileImage = await SharedPreferences.getInstance();
    SharedPreferences prefProfileName = await SharedPreferences.getInstance();
    SharedPreferences prefProfileNumber = await SharedPreferences.getInstance();

    await isActivePref.setBool('isActive', true);
    await prefProfileNumber.setString('profileNumber', numberController);
    await prefProfileName.setString('profileName', nameController);
    await prefProfileImage.setString('profileImage', imageController);
  }

  Future showOptions() async {
    showDialog(
      context: context,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: selectedColor,
              ),
              child: const Text(
                'Photo Gallery',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // close the options modal
                Navigator.of(context).pop();
                // get image from gallery
                getImageFromGallery();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: selectedColor,
              ),
              child: const Text(
                'Camera',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // close the options modal
                Navigator.of(context).pop();
                // get image from camera
                getImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          imageController = pickedFile.path;
        });
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          imageController = pickedFile.path;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
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
        title: MyAppBarTitle(
          fontSize: 46,
          title: imageController != '' ? 'Edit Profile' : 'Create Profile',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    imageController == ''
                        ? CircleAvatar(
                            backgroundColor: selectedColor,
                            radius: size.width / 2 - 30,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: size.width / 2,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: selectedColor,
                            backgroundImage: FileImage(File(imageController)),
                            radius: size.width / 2 - 30,
                          ),
                    GestureDetector(
                      onTap: showOptions,
                      child: Padding(
                        padding: EdgeInsets.all(size.width / 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SettingsCategoryWidget(
                text: 'Name :',
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: nameController,
                  onChanged: (value) {
                    setState(
                      () {
                        nameController = value;
                      },
                    );
                  },
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SettingsCategoryWidget(
                color: Colors.white,
                text: 'Number :',
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  decoration: const InputDecoration(
                    hintText: '09100000000',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  initialValue: numberController,
                  onChanged: (value) {
                    setState(() {
                      if (value.length > 10) {
                        String val1 = value.substring(1, 4);
                        String val2 = value.substring(4, 7);
                        String val3 = value.substring(7);

                        numberController = '$val1 $val2 $val3';
                      }
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: size.height / 10,
              ),
              SizedBox(
                width: size.width - 40,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (nameController == '' || numberController == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '''You must add your profile data to use the app
Your profile data will be unreachable for others.'''),
                        ),
                      );
                    } else {
                      setProfileData();
                      if (checkFirstEntry) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomeScreen();
                            },
                          ),
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
