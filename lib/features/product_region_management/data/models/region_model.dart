import 'dart:convert';

class RegionModel {
  int? id;
  String? name;
  String? country;

  RegionModel({this.id, this.name, this.country});

  factory RegionModel.fromMap(Map<String, dynamic> data) => RegionModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        country: data['country'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'country': country,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegionModel].
  factory RegionModel.fromJson(String data) {
    return RegionModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegionModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
