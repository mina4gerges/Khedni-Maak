import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/utils/custom_app/custom_app_bar_dropdown.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  CustomAppBar({
    Key key,
    this.title = '',
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        iconSize: 28.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[CustomAppBarDropDown()],
    );
  }

  // @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
