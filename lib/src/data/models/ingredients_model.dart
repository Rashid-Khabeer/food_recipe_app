part of models;

@JsonSerializable()
class IngredientsModel extends Model {
  IngredientsModel({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  String name;
  String? quantity;
  String? unit;

  factory IngredientsModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IngredientsModelToJson(this);
}
