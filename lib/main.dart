// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';

import 'bottom.dart';

void main() {
  ThemeData Themdata = ThemeData(brightness: Brightness.dark);
  runApp(MaterialApp(
    theme: Themdata,
    debugShowCheckedModeBanner: false,
    home: const Home_Screen(),
    title: 'ToDo',
  ));
}

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final listController = TextEditingController();
  List<String> todo = [];
  int index = 0;
  Set<int> select = {};
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              buildbottom(Icons.settings, 'Settings', () {}),
              buildbottom(Icons.info, 'info', () {
                showAboutDialog(
                    context: context,
                    applicationName: 'ToDo',
                    children: [
                      Text(
                          'This is a simple todo application with the functions adding work,marking the work and deleting them. ')
                    ]);
              })
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "ToDoList",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          //this is the build method to build the todo list
          Expanded(
            child: ListView.builder(
              itemCount: index,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: select.contains(index),
                      onChanged: (bool? value) {
                        setState(
                          () {
                            if (value!) {
                              select.add(index);
                            } else {
                              select.remove(index);
                            }
                          },
                        );
                      },
                      title: Text(
                        todo[index],
                        style: TextStyle(
                            decoration: select.contains(index)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 1,
                            fontSize: 25,
                            fontStyle: FontStyle.normal,
                            decorationColor: select.contains(index)
                                ? Colors.redAccent
                                : null),
                      ),
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                    ),
                    const Divider(
                      indent: 5,
                      endIndent: 5,
                      height: 20,
                      thickness: 2.0,
                      color: Color.fromARGB(255, 149, 58, 66),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //this icon will add the user input work to the list which is later built by the build method.
          //when user tapped on this button the build method instantly shows the work by adding to the work list.
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0, left: 10, right: 10),
                                child: TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  controller: listController,
                                  decoration: InputDecoration(
                                    hintText: 'Add your work',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Some Text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate())
                                    setState(
                                      () {
                                        todo.add(
                                            listController.text.toString());
                                        ++index;
                                        listController.clear();
                                      },
                                    );
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
