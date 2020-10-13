import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/stat_card.dart';

class DriverScreen extends StatelessWidget {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return BuildStatCard(
          title: "Driver ${entries[index]}",
          body: "Dody driver ${entries[index]}",
          color: Colors.deepOrange,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
