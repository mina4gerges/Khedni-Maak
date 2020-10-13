import 'package:flutter/material.dart';

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

enum TopBarOptions { harder, smarter }

class _CustomAppBarDropDownState extends State<CustomAppBarDropDown> {
  TopBarOptions _selection;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TopBarOptions>(
      icon: widget.icon,
      color: widget.color,
      onSelected: (TopBarOptions result) {
        setState(() {
          _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TopBarOptions>>[
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.harder,
            child: Text('Profile'),
        ),
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.smarter,
          child: Text('Log Out'),
        ),
      ],
    );
  }


}
