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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text("new Jobs"),
      ),
      body: _builContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _builContent() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Placeholder(
              fallbackHeight: 200,
            ),
          ),
        ),
      ),
    );
  }
}
