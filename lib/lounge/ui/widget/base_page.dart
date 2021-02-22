import 'package:flutter/material.dart';

import 'date_picker.dart';

class StudyRoomPage extends StatelessWidget {
  final Widget body;

  const StudyRoomPage({this.body, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff7f7f8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppBar(
              titleSpacing: 0,
              leadingWidth: 12,
              brightness: Brightness.light,
              elevation: 0,
              leading: Icon(
                Icons.arrow_back,
                size: 30,
                color: Color(0XFF62677B),
              ),
              backgroundColor: Colors.transparent,
              actions: [
                TimeCheckWidget(),
              ],
            ),
          ),
        ),
        body: body,
      ),
    );
  }
}