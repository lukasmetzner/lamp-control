import 'package:flutter/material.dart';
import 'package:lamp_control/Widgets/AddLamp/addLamp.dart';
import 'package:lamp_control/Widgets/AddLamp/addLampResult.dart';

import 'Widgets/LampListItem/switchableLamp.dart';
import 'Widgets/Settings/SettingsResult.dart';
import 'Widgets/Settings/settings.dart';

void main() => runApp(MaterialApp(home: Home(),));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lampcontrol"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute<SettingsResult>(builder: (context) =>  Settings())
                );
                //TODO: Save new settings
              },
            ),
          ),
        ],
      ),
      body: null, //TODO: Implement list
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute<AddLampResult>(builder: (context) => AddLamp()),
          );
          //TODO: Add new List Item
        },
      ),
    );
  }
}