part of firestore_service;

class UserFirestoreService extends AppFirestoreService<UserModel> {
  @override
  String get collectionName => 'users';

  @override
  UserModel parseModel(DocumentSnapshot<Object?> document) {
    return UserModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Future<List<UserModel>> popularCreators([int? limit]) async {
    if (limit != null) {
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy("creatorAverage")
          .limit(limit)
          .get()
          .then((value) => value.docs.map((e) => parseModel(e)).toList());
    }
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy("creatorAverage")
        .get()
        .then((value) => value.docs.map((e) => parseModel(e)).toList());
  }
}
