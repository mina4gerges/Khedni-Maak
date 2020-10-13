import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/stat_card.dart';

class DriverScreen extends StatelessWidget {
  final List<String> entries = <String>['Mina Gerges', 'Samer Barhouche', 'Antonios Gerges',"Jad Azar"];
  final List<int> colorCodes = <int>[0xff264653, 0xfff4a261, 0xffe76f51,0xffe9c46a];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return BuildStatCard(
          title: entries[index],
          body: "Body ${entries[index]}",
          color: Color(colorCodes[index]),
        );
      },
    );
  }
}
