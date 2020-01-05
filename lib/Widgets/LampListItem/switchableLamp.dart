import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/SocketService/socketService.dart';

class SwitchableLamp extends StatefulWidget {
  String name;
  Socket _socket;
  bool toggle = false;
  int pin;

  SwitchableLamp(name, socket, pin) {
    this.name = name;
    this._socket = socket;
    this.pin = pin;
  }

  void setSocket(Socket socket) {
    _socket = socket;
  }

  @override
  _SwitchableLampState createState() => _SwitchableLampState(name);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return name;
  }
}

class _SwitchableLampState extends State<SwitchableLamp> {
  String _name;

  _SwitchableLampState(name) {
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
          color: widget.toggle
              ? Color.fromARGB(100, 25, 255, 25)
              : Color.fromARGB(100, 255, 25, 25),
          onPressed: switchLamp,
        )
      ],
    );
  }

  void switchLamp() {
    setState(() {
      widget.toggle = !widget.toggle;
    });
    if (widget._socket != null) {
      widget._socket
          .write(widget.name + ":" + widget.toggle.toString() + ":" + "switch");
    }
  }
}
