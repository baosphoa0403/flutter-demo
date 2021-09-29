import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth_api_path.dart';
import 'package:demoflutter/service/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job?>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});
  final _service = FireStoreService.instance;
  @override
  Future<void> createJob(Job job) async =>
      _service.setData(data: job.toMap(), path: APIPath.job(uid, "job_abc"));
  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.formMap(data));
}
