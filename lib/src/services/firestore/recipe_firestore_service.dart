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

  Stream<List<RecipeModel>> fetchTrending({int? limit}) {
    var lastDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).subtract(
      const Duration(days: 30),
    );
    if (limit != null) {
      return FirebaseFirestore.instance
          .collection(collectionName)
          .where(
            "timestamp",
            isGreaterThan: lastDate,
          )
          .limit(3)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((document) => parseModel(document)).toList()
                ..sort((a, b) => b.rating.compareTo(a.rating)));
    }
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where(
          "timestamp",
          isGreaterThan: lastDate,
        )
        .limit(3)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList()
              ..sort((a, b) => b.rating.compareTo(a.rating)));
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
        .where('category',
            arrayContains: getCategoryKey(category: category))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<List<RecipeModel>> fetchByCreator(String creator) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: creator)
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
        await updateCreatorAverage(userId: userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCreatorAverage({required String userId}) async {
    // Updating average creator rating
    var userRecipes = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .get()
        .then((snap) => snap.docs.map((ds) => parseModel(ds)).toList());
    var rating = 0.0;
    var count = 0;
    if (userRecipes.isNotEmpty) {
      for (var recipe in userRecipes) {
        if (recipe.rating != 0.0 && recipe.rating != 0) {
          rating += recipe.rating;
          count++;
        }
      }

      var user = await UserFirestoreService().fetchOneFirestore(userId);
      if (user != null) {
        user.creatorAverage = rating / count;
        await UserFirestoreService().updateFirestore(user);
      }
    }
  }

  // Future<List<UserModel>> popularCreators([int? limit]) async {
    // var recipes = await fetch();
    // // group recipes with users
    // Map<String, List<RecipeModel>> recipesMap = {};
    // for (var recipe in recipes) {
    //   if (recipesMap[recipe.userId] != null) {
    //     recipesMap[recipe.userId]?.add(recipe);
    //   } else {
    //     recipesMap[recipe.userId] = [recipe];
    //   }
    // }
    //
    // var ids = [];
    // var ratingCount = [];
    // var totalCount = [];
    // var keys = recipesMap.keys.toList();
    // var values = recipesMap.values.toList();
    //
    // for (var i = 0; i < values.length; ++i) {
    //   ids.add(keys[i]);
    //   totalCount.add(values[i].length);
    //   var rating = 0.0;
    //   for (var j = 0; j < values[i].length; ++j) {
    //     rating += values[i][j].rating;
    //   }
    //   ratingCount.add(rating);
    // }
    //
    // var average = [];
    // for (var i = 0; i < totalCount.length; ++i) {
    //   totalCount[i] != 0
    //       ? average.add(ratingCount[i] / totalCount[i])
    //       : average.add(0.0);
    // }
    //
    // Map<String, double> resMap = {};
    // for (var i = 0; i < average.length; ++i) {
    //   resMap[ids[i]] = average[i];
    // }
    //
    // var sortedKeys = resMap.keys.toList(growable: false)
    //   ..sort((k1, k2) => resMap[k1]?.compareTo(resMap[k2] ?? 0) ?? 0);
    // LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
    //     key: (k) => k, value: (k) => resMap[k]);
    //
    // List<UserModel> users = [];
    // var userIds = sortedMap.keys.toList();
    // for (var id in userIds) {
    //   var user = await UserFirestoreService().fetchOneFirestore(id);
    //   if (user != null) {
    //     users.add(user);
    //   }
    // }
    //
    // return limit != null ? users.length > limit ? users.sublist(0, limit) : users : users;
  // }
}