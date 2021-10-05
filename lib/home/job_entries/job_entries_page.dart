import 'dart:async';

import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/home/job_entries/entry_list_item.dart';
import 'package:demoflutter/home/job_entries/entry_page.dart';
import 'package:demoflutter/home/jobs/edit_job_page.dart';
import 'package:demoflutter/home/jobs/list_item_builder.dart';
import 'package:demoflutter/home/models/entry.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class JobEntriesPage extends StatelessWidget {
  JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    // khi navigator not found Provider.of<Database>
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
        deafaultActionTex: 'ok',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final jobName = snapshot.data?.name ?? "";
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => EntryPage.show(
                      context: context, database: database, job: job),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      EditJobPage.show(context, job: job, database: database),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
