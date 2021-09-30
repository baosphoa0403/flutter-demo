import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/home/jobs/add_job_page.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:demoflutter/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    } catch (e) {
      print(e);
    }
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

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: "Blogging", ratePerHours: 10));
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: "operation fail", content: e.code, defaultActionText: "ok");
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
        onPressed: () => AddJobPage.show(context),
      ),
    );
  }

  Widget _buildContext(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs!.map((e) => Text(e!.name)).toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Some error occured"),
          );
        }
        return const Center(
            // child:  CircularProgressIndicator(),
            );
      },
    );
  }
}
