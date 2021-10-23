import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference products =
      FirebaseFirestore.instance.collection("products");
  saveProduct(Map<String, dynamic> data) {
    return products.add(data);
  }

  updateProduct(String id, Map<String, dynamic> data) {
    return products.doc(id).set(data, SetOptions(merge: true));
  }

  deleteProduct(String id, Map<String, dynamic> data) {
    return products.doc(id).delete();
  }
}
