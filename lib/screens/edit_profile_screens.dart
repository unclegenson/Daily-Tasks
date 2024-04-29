import 'dart:io';

import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_note_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

String? _image;
String nameController = '';
String numberController = '';

class _EditProfileScreenState extends State<EditProfileScreen> {
  void readProfileData() {
    print('read');
    return Hive.box<ProfileData>('profileBox').values.forEach(
      (element) {
        setState(() {
          nameController = element.name!;
          numberController = element.number!;
          _image = element.image!;
        });
      },
    );
  }

  Future showOptions() async {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
        _image = pickedFile.path;
        Hive.box<ProfileData>('profileBox').putAt(
          0,
          ProfileData(
            name: nameController,
            number: numberController,
            image: _image.toString(),
          ),
        );
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
        Hive.box<ProfileData>('profileBox').putAt(
          0,
          ProfileData(
            name: nameController,
            number: numberController,
            image: _image.toString(),
          ),
        );
      }
    });
  }

//todo: problem with showing the image for the first time
  @override
  Widget build(BuildContext context) {
    print('--------------------------------------');
    print(Hive.box<ProfileData>('profileBox').length.toString());

    Hive.box<ProfileData>('profileBox').length == 0
        ? Hive.box<ProfileData>('profileBox').add(
            ProfileData(
              name: 'Mohammad Mahdi',
              number: '+98 910 063 9128',
              image:
                  '/data/user/0/com.example.daily_tasks/cache/161dde68-1b06-4985-9c2d-137af4535567/IMG_0155.jpg',
            ),
          )
        : readProfileData();

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
          title: 'Edit Profile',
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
                    CircleAvatar(
                      backgroundColor: selectedColor,
                      backgroundImage: FileImage(File(_image!)),
                      radius: size.width / 2 - 30,
                    ),
                    GestureDetector(
                      onTap: showOptions,
                      child: Padding(
                        padding: EdgeInsets.all(size.width / 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: selectedColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SettingsCategoryWidget(text: 'Name :'),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: nameController,
                  onChanged: (value) {
                    setState(() {
                      nameController = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SettingsCategoryWidget(
                text: 'Number :',
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: numberController,
                  onChanged: (value) {
                    setState(() {
                      numberController = value;
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
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
