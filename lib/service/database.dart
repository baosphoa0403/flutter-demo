import 'package:demoflutter/home/models/entry.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth_api_path.dart';
import 'package:demoflutter/service/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job?>> jobsStream();
  Future<void> deleteJob(Job job);

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
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

  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );
}
