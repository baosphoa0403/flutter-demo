import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth_api_path.dart';
import 'package:demoflutter/service/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job?>> jobsStream();
}

String documentIDFormCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});
  final _service = FireStoreService.instance;
  @override
  Future<void> setJob(Job job) async =>
      await _service.setData(data: job.toMap(), path: APIPath.job(uid, job.id));
  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid),
      builder: (data, documentID) => Job.formMap(data, documentID));
}
