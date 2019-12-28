class Lamp {
  final String name;
  final String type;
  final int pin;

  Lamp({this.name, this.type, this.pin});

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'type' : type,
      'pin' : pin,
    };
  }
}