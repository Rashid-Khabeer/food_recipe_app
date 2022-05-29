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
}
