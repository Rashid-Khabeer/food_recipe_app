part of models;

@JsonSerializable()
class IngredientsModel extends Model {
  IngredientsModel({
    required this.name,
    required this.quantity,
  });

  String name;
  String quantity;

  factory IngredientsModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IngredientsModelToJson(this);
}
