part of firestore_service;

class RecipeFirestoreService extends AppFirestoreService<RecipeModel> {
  @override
  String get collectionName => 'recipes';

  @override
  RecipeModel parseModel(DocumentSnapshot<Object?> document) {
    return RecipeModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Stream<List<RecipeModel>> fetchSaved() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('savedUsersIds', arrayContains: FirebaseAuthService.userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<List<RecipeModel>> fetchTrending() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<List<RecipeModel>> fetchTrendingByLimit() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('rating', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<List<RecipeModel>> fetchRecentByLimit() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<List<RecipeModel>> fetchByCategory(String category) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('category', arrayContains: category)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Future<void> updateRating(
    double rating,
    String userId,
    String recipeId,
  ) async {
    try {
      var model = await fetchOneFirestore(recipeId);
      if (model != null) {
        var index =
            model.ratings.indexWhere((element) => element.personId == userId);
        if (index >= 0) {
          model.ratings[index].rate = rating;
          var totalRating = 0.0;
          for (var rate in model.ratings) {
            totalRating += rate.rate;
          }
          model.rating = totalRating / model.ratings.length;
        } else {
          model.rating =
              model.rating == 0 ? rating : (model.rating + rating) / 2;
          model.ratings.add(RatingModel(personId: userId, rate: rating));
        }
        await updateFirestore(model);
      }
    } catch (e) {
      rethrow;
    }
  }
}