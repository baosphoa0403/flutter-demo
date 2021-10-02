import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/home/jobs/edit_job_page.dart';
import 'package:demoflutter/home/jobs/job_list_title.dart';
import 'package:demoflutter/home/jobs/list_item_builder.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:demoflutter/service/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class JopsPage extends StatelessWidget {
  Future<void> _logoutAnonymous(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {}
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure that you want to logout",
        defaultActionText: "OK",
        cancelActionText: "No");
    if (didRequestSignOut == true) {
      _logoutAnonymous(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // database.readJobs();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => confirmSignOut(context),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              )),
        ],
      ),
      body: _buildContext(context),
      // ignore: prefer_const_constructors
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => EditJobPage.show(context, job: null),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: "Operation failed", exception: e, deafaultActionTex: "ok");
    }
  }

  Widget _buildContext(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            key: Key("job-${job.id}"),
            onDismissed: (direction) => _delete(context, job),
            child: JobListTitle(
              job: job,
              onTap: () => EditJobPage.show(context, job: job),
            ),
          ),
        );
      },
    );
  }
}
