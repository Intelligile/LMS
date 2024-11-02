class Authority {
  dynamic id;
  String? authority;
  dynamic description;
  List<dynamic>? permissionIds;
  List<dynamic>? userIds;

  Authority({
    this.id,
    this.authority,
    this.description,
    this.permissionIds,
    this.userIds,
  });

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        id: json['id'] as dynamic,
        authority: json['authority'] as String?,
        description: json['description'] as String?,
        permissionIds: json['permissionIds'] as List<dynamic>?,
        userIds: json['userIds'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'authority': authority,
        'description': description,
        'permissionIds': permissionIds,
        'userIds': userIds,
      };
}
