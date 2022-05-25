part of firestore_service;

class UserFirestoreService extends AppFirestoreService<UserModel> {
  @override
  String get collectionName => 'users';

  @override
  UserModel parseModel(DocumentSnapshot<Object?> document) {
    return UserModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
