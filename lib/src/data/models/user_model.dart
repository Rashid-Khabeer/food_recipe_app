part of models;

@JsonSerializable()
class UserModel extends Model {
  UserModel({
    required this.email,
    this.name,
    this.bio,
    this.profilePicture,
  });

  String? name;
  String email;
  String? bio;
  String? profilePicture;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
