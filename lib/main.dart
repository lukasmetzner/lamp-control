import 'package:flutter/material.dart';
import 'package:lamp_control/DatabaseService/databaseService.dart';
import 'package:lamp_control/SocketService/socketService.dart';
import 'package:lamp_control/Widgets/AddLamp/addLamp.dart';
import 'package:lamp_control/Widgets/AddLamp/addLampResult.dart';
import 'package:lamp_control/Widgets/AddLamp/lampType.dart';
import 'package:lamp_control/Widgets/LampListItem/setableLamp.dart';

import 'DatabaseService/Lamp.dart';
import 'Widgets/LampListItem/switchableLamp.dart';
import 'Widgets/Settings/SettingsResult.dart';
import 'Widgets/Settings/settings.dart';

void main() {
  SocketService socketService = new SocketService("192.168.0.26", 8080);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: Home(socketService: socketService)));
}

class Home extends StatefulWidget {
  final SocketService socketService;
  DatabaseService databaseService;

  Home({this.socketService}){
    this.databaseService = new DatabaseService();
    this.databaseService.setupDatabase();
  }

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home>{

  List<Widget> _lamps = List<Widget>.generate(0, null);

  @override
  initState(){
    List<Widget> tmpLamps = List<Widget>.generate(0, null);
    widget.databaseService.getLamps().then((lamps) {
      lamps.forEach((lamp) {
        print(lamp.type);
        if(lamp.type == "LampType.SWITCHABLE")
          tmpLamps.add(new SwitchableLamp(lamp.name, widget.socketService));
        else if(lamp.type == "LampType.SETABLE")
          tmpLamps.add(new SetableLamp(lamp.name, widget.socketService));
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
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute<SettingsResult>(builder: (context) =>  Settings())
                );
                setState(() {
                  print(result.port);
                });
                //TODO: Save new settings
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _lamps.length,
            itemBuilder: (context, index) {
              var lamp = _lamps[index];
              return Dismissible(
                key: Key(lamp.toString()),
                child: lamp,
                onDismissed: (direction){
                  setState(() {
                    _lamps.removeAt(index);
                    widget.databaseService.deleteLamp(lamp.toString()).then((data) {
                      Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(lamp.toString() + " removed"),));
                    });
                  });
                },
              );
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute<AddLampResult>(builder: (context) => AddLamp()),
          );
          setState(() {
            if(result != null){
              if(result.lampType == LampType.SETABLE)
                _lamps.add(new SetableLamp(result.lampName, widget.socketService));
              else if (result.lampType == LampType.SWITCHABLE)
                _lamps.add(new SwitchableLamp(result.lampName, widget.socketService));
            }
          });
          widget.databaseService.insertLamp(
              Lamp(
                  name: result.lampName,
                  type: result.lampType.toString()
              )
          );
          //TODO: Add new lamp to database
        },
      ),
    );
  }
}