import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference products =
      FirebaseFirestore.instance.collection("products");
  Future<DocumentReference<Object?>> saveProduct(Map<String, dynamic> data) {
    data["createdAt"] = DateTime.now().toUtc().toIso8601String();
    return products.add(data);
  }

  ///Upload a File passed in parameter to firebase storage and return the Download URL
  Future<String> uploadFileToFireStorage(File file) async {
    var ref = FirebaseStorage.instance.ref('uploads');

    var uploadedFile = await ref.putFile(file);
    return await uploadedFile.ref.getDownloadURL();
  }

  updateProduct(String id, Map<String, dynamic> data) {
    data["updatedAt"] = DateTime.now().toUtc().toIso8601String();
    return products.doc(id).set(data, SetOptions(merge: true));
  }

  deleteProduct(String id, Map<String, dynamic> data) {
    return products.doc(id).delete();
  }
}
