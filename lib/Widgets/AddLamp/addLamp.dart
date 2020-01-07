import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/Widgets/AddLamp/addLampResult.dart';
import 'package:lamp_control/Widgets/AddLamp/lampType.dart';

class AddLamp extends StatefulWidget {
  @override
  _AddLampState createState() => _AddLampState();
}

class _AddLampState extends State<AddLamp> {
  final _globalKey = GlobalKey<FormState>();
  final lampNameController = TextEditingController();
  final pinController = TextEditingController();
  String dropdownValue = 'Switchable';
  LampType _lampType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Lampensteuerung"),
        ),
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: lampNameController,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter a name";
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lightbulb_outline),
                    labelText: 'Lamp identifier',
                  ),
                ),
                TextFormField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter a pin";
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.pin_drop),
                    labelText: 'Pin',
                  ),
                ),
                DropdownButtonFormField(
                  value: dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Switchable', 'Setable']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: addLamp,
      ),
    );
  }

  void addLamp() {
    if (_globalKey.currentState.validate()) {
      if (dropdownValue == "Switchable")
        _lampType = LampType.SWITCHABLE;
      else if (dropdownValue == "Setable") _lampType = LampType.SETABLE;
      Navigator.pop(
          context,
          new AddLampResult(lampNameController.text, _lampType,
              int.parse((pinController.text))));
    }
  }
}
