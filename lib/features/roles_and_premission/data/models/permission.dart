class Permission {
  dynamic id;
  String? permission;
  String? permissionDescription;
  List<dynamic>? authorityIds;

  Permission({
    this.id,
    this.permission,
    this.permissionDescription,
    this.authorityIds,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json['id'] as dynamic,
        permission: json['permission'] as String?,
        permissionDescription: json['permissionDescription'] as String?,
        authorityIds: json['authorityIds'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'permission': permission,
        'permissionDescription': permissionDescription,
        'authorityIds': authorityIds,
      };
}
