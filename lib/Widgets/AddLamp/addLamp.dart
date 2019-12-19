import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/Widgets/AddLamp/addLampResult.dart';
import 'package:lamp_control/Widgets/AddLamp/lampType.dart';

class AddLamp extends StatefulWidget {
  @override
  _AddLampState createState() => _AddLampState();
}

class _AddLampState extends State<AddLamp> {

  final lampNameController = TextEditingController();
  String dropdownValue = 'Setable';
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
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: lampNameController,
              //TODO: Validator
              decoration: const InputDecoration(
                icon: Icon(Icons.lightbulb_outline),
                labelText: 'Lamp identifier',
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: (){
          if(dropdownValue == "Switchable")
            _lampType = LampType.SWITCHABLE;
          else if(dropdownValue == "Setable")
            _lampType = LampType.SETABLE;
          Navigator.pop(context, new AddLampResult(lampNameController.text, _lampType));
        },
      ),
    );
  }

}