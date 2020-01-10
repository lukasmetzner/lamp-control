import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetableLamp extends StatefulWidget {
  String name;
  Socket _socket;
  int pin;

  SetableLamp(name, socket, pin) {
    this.name = name;
    this._socket = socket;
    this.pin = pin;
  }

  void setSocket(Socket socket) {
    _socket = socket;
  }

  @override
  _SetableLampState createState() => _SetableLampState(name);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return name;
  }
}

class _SetableLampState extends State<SetableLamp> {
  String _name;
  double _sliderValue = 0;
  _SetableLampState(name) : this._name = name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(_name),
        ),
        Flexible(
          child: Slider(
            min: 0,
            max: 255,
            value: _sliderValue,
            onChanged: (value) {
              sendInput(value);
              setState(() {
                _sliderValue = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void sendInput(double value) {
    if (widget._socket != null)
      widget._socket
          .write(widget.name + ":" + value.round().toString() + ":" + "set");
  }
}
