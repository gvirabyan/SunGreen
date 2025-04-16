class Plant {
  final String id;

  final String name;
  final String type;


  Plant({required this.id,required this.name,required this.type});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(id: json['id'],name: json['name'], type: json['type']);
  }
}