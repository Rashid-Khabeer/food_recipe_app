part of models;

@JsonSerializable()
class RatingModel extends Model {
  RatingModel({
    required this.personId,
    required this.rate,
  });

  String personId;
  double rate;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
