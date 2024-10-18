// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegionProductModel {
  int? id;
  String name;
  String description;
  double price;
  String imageUrl;
  int regionId;

  RegionProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.regionId,
  });

  RegionProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? regionId,
  }) {
    return RegionProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      regionId: regionId ?? this.regionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'regionId': regionId,
    };
  }

  factory RegionProductModel.fromMap(Map<String, dynamic> map) {
    return RegionProductModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      regionId: map['regionId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegionProductModel.fromJson(String source) =>
      RegionProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RegionProductModel(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, regionId: $regionId)';
  }

  @override
  bool operator ==(covariant RegionProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.regionId == regionId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        regionId.hashCode;
  }
}
