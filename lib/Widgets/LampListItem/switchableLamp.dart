import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/SocketService/socketService.dart';

class SwitchableLamp extends StatefulWidget {
  String name;
  SocketService _socketService;
  bool toggle = false;

  SwitchableLamp(name, socketService){
    this.name = name;
    this._socketService = socketService;
  }

  @override
  _SwitchableLampState createState() => _SwitchableLampState(name);

  @override
  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.debug }) {
    return name;
  }
}

class _SwitchableLampState extends State<SwitchableLamp>{
  String _name;

  _SwitchableLampState(name){
    this._name = name;
  }

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
          color: widget.toggle ? Color.fromARGB(100, 25, 255, 25) : Color.fromARGB(100, 255, 25, 25),
          onPressed: () {
            setState(() {
              widget.toggle = !widget.toggle;
            });
            widget._socketService.getSocket().write(widget.name + " " + widget.toggle.toString() + "\n");
          },
        )
      ],
    );
  }
}