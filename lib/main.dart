import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lamp_control/DatabaseService/databaseService.dart';
import 'package:lamp_control/SocketService/socketService.dart';
import 'package:lamp_control/Widgets/AddLamp/addLamp.dart';
import 'package:lamp_control/Widgets/AddLamp/addLampResult.dart';
import 'package:lamp_control/Widgets/AddLamp/lampType.dart';
import 'package:lamp_control/Widgets/LampListItem/setableLamp.dart';
import 'package:lamp_control/Widgets/Settings/settingsResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DatabaseService/Lamp.dart';
import 'Widgets/LampListItem/switchableLamp.dart';
import 'Widgets/Settings/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  SocketService socketService;
  DatabaseService databaseService;
  SharedPreferences config;

  Home() {
    this.databaseService = new DatabaseService();
    this.databaseService.setupDatabase();
    SharedPreferences.getInstance().then((pref) {
      this.config = pref;
      this.socketService =
          new SocketService(this.config.get("ip"), this.config.get("port"));
    });
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _lamps = List<Widget>.generate(0, null);

  @override
  initState() {
    List<Widget> tmpLamps = List<Widget>.generate(0, null);
    widget.databaseService.getLamps().then((lamps) {
      lamps.forEach((lamp) {
        if (lamp.type == "LampType.SWITCHABLE")
          tmpLamps.add(
              new SwitchableLamp(lamp.name, widget.socketService, lamp.pin));
        else if (lamp.type == "LampType.SETABLE")
          tmpLamps
              .add(new SetableLamp(lamp.name, widget.socketService, lamp.pin));
      });
      setState(() {
        _lamps.addAll(tmpLamps);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lampensteuerung"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                final result = await Navigator.push<SettingsResult>(
                    context,
                    MaterialPageRoute<SettingsResult>(
                        builder: (context) => Settings()));
                setState(() {
                  if (result != null) {
                    widget.config.setString("ip", result.raspiIp);
                    widget.config.setInt("port", result.port);
                    widget.socketService =
                        new SocketService(result.raspiIp, result.port);
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
        itemCount: _lamps.length,
        itemBuilder: dismissableItemBuilder,
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addButtonPressed,
      ),
    );
  }

  Widget dismissableItemBuilder(BuildContext context, int index) {
    var lamp = _lamps[index];
    return Dismissible(
        key: Key(lamp.toString()),
        child: lamp,
        onDismissed: (direction) {
          setState(() {
            _lamps.removeAt(index);
            widget.databaseService.deleteLamp(lamp.toString()).then((data) {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(lamp.toString() + " removed"),
                ));
            });
            if (widget.socketService.getSocket() != null)
              switch (lamp.runtimeType) {
                case SwitchableLamp:
                  var tmp = lamp as SwitchableLamp;
                  widget.socketService.getSocket().write(tmp.name +
                      ":" +
                      tmp.pin.toString() +
                      ":" +
                      "true" +
                      ":" +
                      "remove");
                  break;
                case SetableLamp:
                  var tmp = lamp as SetableLamp;
                  widget.socketService.getSocket().write(tmp.name +
                      ":" +
                      tmp.pin.toString() +
                      ":" +
                      "false" +
                      ":" +
                      "remove");
                  break;
              }
          });
        });
  }

  void addButtonPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<AddLampResult>(builder: (context) => AddLamp()),
    );
    setState(() {
      if (result != null) {
        if (result.lampType == LampType.SETABLE)
          _lamps.add(new SetableLamp(
              result.lampName, widget.socketService, result.pin));
        else if (result.lampType == LampType.SWITCHABLE)
          _lamps.add(new SwitchableLamp(
              result.lampName, widget.socketService, result.pin));
      }
    });
    if (result != null) {
      widget.databaseService.insertLamp(Lamp(
        name: result.lampName,
        type: result.lampType.toString(),
        pin: result.pin,
      ));
      if (widget.socketService.getSocket() != null) {
        if (result.lampType == LampType.SWITCHABLE)
          widget.socketService.getSocket().write(result.lampName +
              ":" +
              result.pin.toString() +
              ":" +
              "true" +
              ":" +
              "add");
        if (result.lampType == LampType.SETABLE)
          widget.socketService.getSocket().write(result.lampName +
              ":" +
              result.pin.toString() +
              ":" +
              "false" +
              ":" +
              "add");
      }
    }
  }
}
