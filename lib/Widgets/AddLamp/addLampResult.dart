import 'package:lamp_control/Widgets/AddLamp/lampType.dart';

class AddLampResult {
  final String _lampName;
  final LampType _lampType;

  AddLampResult(this._lampName, this._lampType);

  LampType get lampType => _lampType;

  String get lampName => _lampName;


}