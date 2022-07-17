part of models;

@JsonSerializable(explicitToJson: true)
class RecipeModel extends Model {
  RecipeModel({
    required this.name,
    required this.spanishName,
    required this.englishName,
    required this.imagesList,
    required this.rating,
    required this.userId,
    required this.category,
    required this.cookingTime,
    required this.ingredients,
    required this.spanishIngredients,
    required this.englishIngredients,
    required this.ratings,
    required this.savedUsersIds,
    required this.serves,
    required this.steps,
    required this.spanishSteps,
    required this.englishSteps,
    required this.timestamp,
  });

  String name;
  String spanishName;
  String englishName;
  List<String> imagesList;
  String serves;
  String cookingTime;
  List<String> category;
  List<IngredientsModel> ingredients;
  List<IngredientsModel> spanishIngredients;
  List<IngredientsModel> englishIngredients;
  List<StepsModel> steps;
  List<StepsModel> spanishSteps;
  List<StepsModel> englishSteps;
  String userId;
  List<String> savedUsersIds;
  double rating;
  List<RatingModel> ratings;
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp timestamp;

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}
