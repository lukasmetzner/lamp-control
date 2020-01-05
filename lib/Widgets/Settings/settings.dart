import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/Widgets/Settings/settingsResult.dart';

class Settings extends StatefulWidget {
  String _ip;
  String _port;

  Settings(ip, port) {
    this._ip = ip;
    this._port = port;
  }

  @override
  _SettingsState createState() => _SettingsState(_ip, _port);
}

class _SettingsState extends State<Settings> {
  final _globalKey = GlobalKey<FormState>();
  final raspiIpController = TextEditingController();
  final portController = TextEditingController();

  _SettingsState(ip, port) {
    raspiIpController.text = ip;
    portController.text = port;
  }

  @override
  void dispose() {
    raspiIpController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "Please enter a IP address";
                  return null;
                },
                controller: raspiIpController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.desktop_windows),
                  labelText: 'Raspberry IP',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "Please enter the port number";
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: portController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.apps),
                  labelText: 'Server Port',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_globalKey.currentState.validate())
            Navigator.pop(
                context,
                new SettingsResult(
                    raspiIpController.text, int.parse(portController.text)));
        },
      ),
    ));
  }
}
