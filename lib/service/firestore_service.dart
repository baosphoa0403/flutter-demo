import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();

  Future<void> setData({String path = "", Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data!);
  }

  Stream<List<T>> collectionStream<T>(
      {String? path,
      T Function(Map<String, dynamic> data, String documentID)? builder}) {
    final reference = FirebaseFirestore.instance.collection(path!);
    final snapshots = reference.snapshots();
    return snapshots.map((item) => item.docs
        .map((e) => builder!(e.data(), e.id))
        .toList()); // get id ở đây
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print("delete: ${path}");
    await reference.delete();
  }
}
