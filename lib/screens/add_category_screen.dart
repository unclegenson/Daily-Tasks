import 'package:daily_tasks/models/models.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

String? newCategory = '';
TextEditingController con = TextEditingController();

bool wantToChange = false;
int indexx = 0;

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  void initState() {
    wantToChange = false;
    con.clear();
    newCategory = '';
    categoryItems.clear();

    Hive.box<Categories>('categoryBox').values.forEach((element) {
      categoryItems.add(element.name);
    });

    super.initState();
  }

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
        backgroundColor: Colors.black87,
        title: const MyAppBarTitle(
          fontSize: 46,
          title: 'Categories',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: size.height * 8.2 / 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 6 / 10,
                  child: ListView.builder(
                    itemCount: categoryItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 8),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              wantToChange = true;
                              indexx = index;
                              newCategory = categoryItems[index];
                              con.text = newCategory!;
                            });
                          },
                        ),
                        title: Text(
                          categoryItems[index],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                        leading: const Icon(Icons.circle),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SettingsCategoryWidget(
                      color: Colors.white,
                      text:
                          !wantToChange ? 'Add Category :' : 'Edit Category :'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                  child: TextFormField(
                    controller: con,
                    onChanged: (value) {
                      setState(() {
                        newCategory = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
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
                    onPressed: () {
                      if (wantToChange) {
                        if (newCategory != '') {
                          setState(() {
                            categoryItems.add(newCategory);
                            categoryItems.removeAt(indexx);
                          });
                          Hive.box<Categories>('categoryBox')
                              .putAt(indexx, Categories(name: newCategory));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit the task please!',
                              ),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        }
                      } else {
                        if (newCategory != '') {
                          setState(() {
                            categoryItems.add(newCategory);
                          });
                          Hive.box<Categories>('categoryBox')
                              .add(Categories(name: newCategory));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Nothing added!',
                              ),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        }
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
      ),
    );
  }
}
