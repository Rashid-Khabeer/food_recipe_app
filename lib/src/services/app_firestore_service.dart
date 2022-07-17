library firestore_service;

import 'dart:collection';
import 'package:async/async.dart' show StreamGroup;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_recipie_app/src/base/data.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';

part 'firestore/recipe_firestore_service.dart';

part 'firestore/user_firestore_service.dart';

abstract class AppFirestoreService<T extends Model> {
  String get collectionName;

  T parseModel(DocumentSnapshot document);

  Future<List<T>> fetch() => FirebaseFirestore.instance
      .collection(collectionName)
      .get()
      .then((snap) => snap.docs.map((ds) => parseModel(ds)).toList());

  Future<List<T>> fetchSelected(dynamic isEqualTo, String where) async =>
      FirebaseFirestore.instance
          .collection(collectionName)
          .where(where, isEqualTo: isEqualTo)
          .get()
          .then((snap) => snap.docs.map((ds) => parseModel(ds)).toList());

  Stream<List<T>> fetchSelectedStream(dynamic isEqualTo, String where) =>
      FirebaseFirestore.instance
          .collection(collectionName)
          .where(where, isEqualTo: isEqualTo)
          .snapshots()
          .map((snap) => snap.docs.map((ds) => parseModel(ds)).toList());

  Stream<List<T>> fetchAllFirestore() => FirebaseFirestore.instance
      .collection(collectionName)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((document) => parseModel(document)).toList());

  Future<List<T>> fetchAllFirestoreFuture() => FirebaseFirestore.instance
      .collection(collectionName)
      .get()
      .then((value) =>
          value.docs.map((document) => parseModel(document)).toList());

  Stream<List<T>> fetchAllSortedFirestore() => FirebaseFirestore.instance
      .collection(collectionName)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<T>> fetchAllSortedWithLimitFirestore({int? limit}) {
    if (limit != null) {
      return FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((document) => parseModel(document)).toList());
    }
    return FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => parseModel(document)).toList());
  }

  Stream<T> fetchOneStreamFirestore(String id) {
    if (id.isEmpty) {
      throw 'No Data';
    }
    try {
      var _response = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .snapshots();
      return _response.map((snapshot) => parseModel(snapshot));
    } catch (_) {
      rethrow;
    }
  }

  Future<T?> fetchOneFirestore(String id) async {
    var _res = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .get();
    if (_res.exists) {
      return parseModel(_res);
    } else {
      return null;
    }
  }

  Future<T> insertFirestore(T model) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection(collectionName)
          .add(model.toJson());
      model.id = document.id;
      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future insertFirestoreWithId(T model) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future updateFirestore(T model) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future deleteFirestore(String documentId) async {
    try {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
