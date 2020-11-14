import 'package:flutter/material.dart';
import 'package:khedni_maak/login/login_screen.dart';

class CustomAppBarDropDown extends StatefulWidget {
  @override
  _CustomAppBarDropDownState createState() => _CustomAppBarDropDownState();
}

enum TopBarOptions { profile, logout }

class _CustomAppBarDropDownState extends State<CustomAppBarDropDown> {

  void onSelected(TopBarOptions selected) {

    if(TopBarOptions.logout == selected){
      logout();
    }
    else if(TopBarOptions.profile == selected){
      print("profile");
    }
  }

  void logout(){
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('userPreference');
    // await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),

      // this function should return true when we're done removing routes
      // but because we want to remove all other screens, we make it
      // always return false
          (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TopBarOptions>(
      onSelected: (TopBarOptions result) {
        onSelected(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TopBarOptions>>[
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.profile,
          child: ListTile(leading: const Icon(Icons.person), title: Text('Profile'),),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<TopBarOptions>(
          value: TopBarOptions.logout,
          child: ListTile(leading: const Icon(Icons.logout), title: Text('Logout'),),
        ),
      ],
    );
  }
}
