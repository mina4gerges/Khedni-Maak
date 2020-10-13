import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        iconSize: 28.0,
        onPressed: () {Navigator.of(context).pop();},
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 28.0,
          onPressed: () {},
        ),
      ],
    );
  }

  // @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
