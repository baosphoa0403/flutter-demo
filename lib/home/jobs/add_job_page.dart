import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddJobPage(), fullscreenDialog: true));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late int _ratePerHours;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      print("form saved ${_name} - ${_ratePerHours}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text("new Jobs"),
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
        decoration: const InputDecoration(label: Text("Job Name")),
        validator: (value) => value!.isEmpty ? "Name can not empty " : null,
        onSaved: (value) => _name =
            value!, // dùng onsave update variable local , widget rebuild not required => don't call setSTate
      ),
      TextFormField(
        decoration: const InputDecoration(label: Text("Rate per hour")),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        onSaved: (value) => _ratePerHours = int.parse(value!),
        validator: (value) =>
            value!.isEmpty ? "Rate per hour can not empty " : null,
      )
    ];
  }
}
