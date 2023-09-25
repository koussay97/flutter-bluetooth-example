import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.teal,
          centerTitle: true,

          title: const Text(
            'welcome to ESP32', style: TextStyle(color: Colors.white),)),
      body:Center(child: Text('im you body ')),);
  }
}
