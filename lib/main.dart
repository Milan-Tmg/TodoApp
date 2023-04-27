// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'bottom.dart';

void main() {
  // ThemeData Themdata = ThemeData(brightness: Brightness.dark);
  runApp(MaterialApp(
    // theme: Themdata,
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

  String formattedDateTime =
      DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  String month = DateFormat('MMM').format(DateTime.now());
  String day = DateFormat('EEEE').format(DateTime.now());
  Color first = Colors.purple;
  Color second = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Icon(
            Icons.list_alt_outlined,
          ),
        ],
      ),
      backgroundColor:
          Color.alphaBlend(first.withOpacity(0.7), second.withOpacity(0.6)),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 132, 86, 128),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Color.fromARGB(255, 109, 79, 118),
                thickness: 1,
              ),
              buildbottom(Icons.settings, 'Settings', () {}),
              buildbottom(Icons.info, 'info', () {
                showAboutDialog(
                    context: context,
                    applicationName: 'ToDo List',
                    children: [
                      Text(
                          'This is a simple todo application with the functions adding work,marking  and deleting.')
                    ]);
              })
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Text(
                  DateTime.now().day.toString(),
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      day,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      month + '\t\t' + (DateTime.now().year.toString()),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              '  Today\'s WorkList',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),

          //this is the build method to build the todo list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 184, 221),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (BuildContext context, index) {
                    final item = todo[index];
                    return Dismissible(
                      confirmDismiss: (direction) async {
                        final bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 186, 161, 186),
                                title: Text('Confirm'),
                                content: Text(
                                    'Are you sure want to delete this item?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Yes')),
                                ],
                              );
                            });
                        return confirm;
                      },
                      background: Container(
                          color: Colors.red, child: Icon(Icons.delete)),
                      movementDuration: Duration(milliseconds: 300),
                      key: Key(item),
                      onDismissed: (direction) {
                        setState(() {
                          todo.removeAt(index);
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: select.contains(index)
                                  ? Color.fromARGB(255, 228, 158, 247)
                                  : Colors.transparent,
                            ),
                            child: CheckboxListTile(
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
                                    color: Colors.black,
                                    decoration: select.contains(index)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationThickness: 1,
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal,
                                    decorationColor: select.contains(index)
                                        ? Colors.redAccent
                                        : null),
                              ),
                              subtitle: Text(
                                formattedDateTime,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 139, 124, 124)),
                              ),
                              activeColor: Colors.redAccent,
                              checkColor: Colors.white,
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 192, 237, 236),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                SizedBox(
                  height: 40,
                  width: 50,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.pinkAccent),
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color.fromARGB(255, 66, 245, 132),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(255, 187, 181, 181),
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
