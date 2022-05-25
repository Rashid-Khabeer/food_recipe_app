library models;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models/_models.dart';

part 'models/user_model.dart';

part 'models/ingredients_model.dart';

part 'models/steps_model.dart';

part 'models/rating_model.dart';

part 'models/recipe_model.dart';

part 'models.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;
