import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const DrawerListTile({
    required this.icon,
    required this.text,
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
      onTap: () async {
        final result = await Share.shareWithResult(
            'check out my website https://example.com');

        if (result.status == ShareResultStatus.success) {
          print('Thank you for sharing my website!');
        }
      },
    );
  }
}
