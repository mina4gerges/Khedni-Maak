import 'dart:io' show Platform;

import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/utils/custom_app/custom_app_bar_dropdown.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.title,
    this.onBackClick,
  }) : super(key: key);

  final Widget title;
  final VoidCallback onBackClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      title: title,
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: Platform.isIOS
            ? const Icon(FlevaIcons.arrow_ios_back)
            : const Icon(FlevaIcons.arrow_back),
        iconSize: 28.0,
        onPressed: () {
          if (onBackClick != null) onBackClick();
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[CustomAppBarDropDown()],
    );
  }

  // @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
