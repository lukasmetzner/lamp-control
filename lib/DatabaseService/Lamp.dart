class Lamp {
  final String name;
  final String type;

  Lamp({this.name, this.type});

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'type' : type,
    };
  }
}