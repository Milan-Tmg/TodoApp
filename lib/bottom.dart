import 'package:flutter/material.dart';

Widget buildbottom(IconData icon, String text, VoidCallback click) {
  return ListTile(
    contentPadding: const EdgeInsets.only(top: 20),
    leading: IconButton(
      onPressed: click,
      icon: Icon(
        icon,
        size: 30,
      ),
    ),
    title: Text(
      text.toString(),
      style: const TextStyle(fontSize: 20),
    ),
  );
}
