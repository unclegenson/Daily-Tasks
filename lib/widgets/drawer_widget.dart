import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? func;
  const DrawerListTile({
    required this.icon,
    required this.text,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(text),
      onTap: func,
    );
  }
}
