import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth_api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job?>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});

  @override
  Future<void> createJob(Job job) async =>
      _setData(data: job.toMap(), path: APIPath.job(uid, "job_abc"));

  Future<void> _setData({String path = "", Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data!);
  }

  @override
  Stream<List<Job?>> jobsStream() => _collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.formMap(data));

  Stream<List<T>> _collectionStream<T>(
      {String? path, T Function(Map<String, dynamic> data)? builder}) {
    final reference = FirebaseFirestore.instance.collection(path!);
    final snapshots = reference.snapshots();
    return snapshots
        .map((item) => item.docs.map((e) => builder!(e.data())).toList());
  }
}
