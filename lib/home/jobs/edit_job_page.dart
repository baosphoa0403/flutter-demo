import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/home/models/job.dart';
import 'package:demoflutter/service/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, required this.job})
      : super(key: key);
  final Database database;
  final Job? job;
  static Future<void> show(BuildContext context, {required Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  int _ratePerHours = 0;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHours = widget.job!.ratePerHours;
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e!.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: "Name already used",
              content: "Please choosen a different job name",
              defaultActionText: "ok");
          return;
        }
        final String id = widget.job?.id ?? documentIDFormCurrentDate();
        final Job job = Job(name: _name, ratePerHours: _ratePerHours, id: id);
        await widget.database.setJob(job);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "error", exception: e, deafaultActionTex: "ok");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "new Jobs" : "edit job"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: _submit,
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _builContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _builContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: const InputDecoration(label: Text("Job Name")),
        validator: (value) => value!.isEmpty ? "Name can not empty " : null,
        onSaved: (value) => _name = value!,
        // dùng onsave update variable local , widget rebuild not required => don't call setSTate
      ),
      TextFormField(
        initialValue: _ratePerHours == 0 ? "" : _ratePerHours.toString(),
        decoration: const InputDecoration(label: Text("Rate per hour")),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        onSaved: (value) => _ratePerHours = int.tryParse(value!) ?? 0,
        validator: (value) =>
            value!.isEmpty ? "Rate per hour can not empty " : null,
      )
    ];
  }
}
