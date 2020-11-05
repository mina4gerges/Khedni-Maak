import 'package:flutter/material.dart';

class BuildStatCard extends StatelessWidget {
  BuildStatCard({
    Key key,
    this.title,
    this.body,
    this.color,
    this.onCarTap,
  }) : super(key: key);

  final Widget title;
  final Widget body;
  final Color color;
  final VoidCallback onCarTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5.0),
            title ?? Container(),
            body,
            SizedBox(height: 5.0),
          ],
        ),
        onTap:onCarTap,
      ),
      elevation: 5,
    );
  }
}
