import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchableLamp extends StatefulWidget {
  String _name;
  SwitchableLamp(name) : this._name = name;
  @override
  _SwitchableLampState createState() => _SwitchableLampState(_name);
}

class _SwitchableLampState extends State<SwitchableLamp>{
  String _name;
  bool btnToggle = false;
  _SwitchableLampState(name) : this._name = name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(_name),
        ),
        RaisedButton(
          child: Icon(Icons.lightbulb_outline),
          color: btnToggle ? Color.fromARGB(100, 25, 255, 25) : Color.fromARGB(100, 255, 25, 25),
          onPressed: () {
            setState(() {
              btnToggle = !btnToggle;
            });
            //TODO: switch lamp
          },
        )
      ],
    );
  }
}