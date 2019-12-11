import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetableLamp extends StatefulWidget {
  String _name;
  SetableLamp(name) : this._name = name;
  @override
  _SetableLampState createState() => _SetableLampState(_name);
}

class _SetableLampState extends State<SetableLamp>{
  String _name;
  _SetableLampState(name) : this._name = name;
  final setValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(_name),
        TextFormField(
          controller: setValueController,
          decoration: const InputDecoration(
            labelText: 'Set Value',
          ),
        ),
        RaisedButton(
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            //TODO: Set lamp
          },
        )
      ],
    );
  }

}