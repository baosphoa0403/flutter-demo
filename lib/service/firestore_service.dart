import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();

  Future<void> setData({String path = "", Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data!);
  }

  Stream<List<T>> collectionStream<T>(
      {String? path, T Function(Map<String, dynamic> data)? builder}) {
    final reference = FirebaseFirestore.instance.collection(path!);
    final snapshots = reference.snapshots();
    return snapshots
        .map((item) => item.docs.map((e) => builder!(e.data())).toList());
  }
}
