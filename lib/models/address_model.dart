import 'dart:convert';

class AddressModel {
  final String id;
  final String idStudent;
  final String nameStudent;
  final String name;
  final String faculty;
  final String time;
  final String building;
  final String images;
  AddressModel({
    required this.id,
    required this.idStudent,
    required this.nameStudent,
    required this.name,
    required this.faculty,
    required this.time,
    required this.building,
    required this.images,
  });

  AddressModel copyWith({
    String? id,
    String? idStudent,
    String? nameStudent,
    String? name,
    String? faculty,
    String? time,
    String? building,
    String? images,
  }) {
    return AddressModel(
      id: id ?? this.id,
      idStudent: idStudent ?? this.idStudent,
      nameStudent: nameStudent ?? this.nameStudent,
      name: name ?? this.name,
      faculty: faculty ?? this.faculty,
      time: time ?? this.time,
      building: building ?? this.building,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStudent': idStudent,
      'nameStudent': nameStudent,
      'name': name,
      'faculty': faculty,
      'time': time,
      'building': building,
      'images': images,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      idStudent: map['idStudent'],
      nameStudent: map['nameStudent'],
      name: map['name'],
      faculty: map['faculty'],
      time: map['time'],
      building: map['building'],
      images: map['images'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, idStudent: $idStudent, nameStudent: $nameStudent, name: $name, faculty: $faculty, time: $time, building: $building, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.idStudent == idStudent &&
        other.nameStudent == nameStudent &&
        other.name == name &&
        other.faculty == faculty &&
        other.time == time &&
        other.building == building &&
        other.images == images;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idStudent.hashCode ^
        nameStudent.hashCode ^
        name.hashCode ^
        faculty.hashCode ^
        time.hashCode ^
        building.hashCode ^
        images.hashCode;
  }
}
