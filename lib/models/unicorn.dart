// lib/models/unicorn.dart
class Unicorn {
  final String id; // comes from the API (`_id` field)
  final String name;
  final int age;
  final String colour;

  Unicorn({
    required this.id,
    required this.name,
    required this.age,
    required this.colour,
  });

  factory Unicorn.fromJson(Map<String, dynamic> json) => Unicorn(
        id: json['_id'],
        name: json['name'],
        age: json['age'],
        colour: json['colour'],
      );

  Map<String, dynamic> toJson() => {
        // '_id': id,
        'name': name,
        'age': age,
        'colour': colour,
      };
}
