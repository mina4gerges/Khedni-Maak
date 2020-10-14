import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CustomAppBarDropDown extends StatefulWidget {
  CustomAppBarDropDown({
    Key key,
    this.icon = const Icon(Icons.menu),
    this.color,
  }) : super(key: key);

  final Icon icon;
  final Color color;

  @override
  _CustomAppBarDropDownState createState() => _CustomAppBarDropDownState();
}

enum TopBarOptions { profile, logout }

class _CustomAppBarDropDownState extends State<CustomAppBarDropDown> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TopBarOptions>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TopBarOptions>>[
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.profile,
          child: ListTile(
              leading: Icon(Icons.person), title: Text('Profile')),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.logout,
          child: ListTile(
              leading: Icon(Icons.logout), title: Text('Logout')),
        ),
      ],
    );
  }
}
