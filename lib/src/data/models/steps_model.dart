part of models;

@JsonSerializable()
class StepsModel extends Model {
  StepsModel({
    required this.step,
    this.image,
  });

  String step;
  String? image;

  factory StepsModel.fromJson(Map<String, dynamic> json) =>
      _$StepsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StepsModelToJson(this);
}
