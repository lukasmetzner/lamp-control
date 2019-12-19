import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamp_control/SocketService/socketService.dart';

class SetableLamp extends StatefulWidget{
  String name;
  SocketService _socketService;

  SetableLamp(name, socketService){
    this.name = name;
    this._socketService = socketService;
  }
  @override
  _SetableLampState createState() => _SetableLampState(name);

  @override
  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.debug }) {
    return name;
  }

}

class _SetableLampState extends State<SetableLamp>{
  String _name;
  _SetableLampState(name) : this._name = name;
  final setValueController = TextEditingController();

  @override
  void dispose(){
    setValueController.dispose();
    super.dispose();
  }

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
          child: TextFormField(
              controller: setValueController,
              decoration: const InputDecoration(
                labelText: 'Set Value',
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: RaisedButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              //TODO Validate input
              int tmp = int.parse(setValueController.text);
              if(tmp > 0){
                widget._socketService.getSocket().write(widget.name + " " + setValueController.text + "\n");
                setState(() {
                  setValueController.text = "";
                });
              }
            },
          ),
        ),
      ],
    );
  }
}