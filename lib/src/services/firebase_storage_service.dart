import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageService {
  static final _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadFile(String path) async {
    try {
      final _fileName = DateTime.now().toIso8601String();
      final _reference = _firebaseStorage.ref().child(_fileName);
      final _task = await _reference.putFile(File(path));
      return await _task.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
