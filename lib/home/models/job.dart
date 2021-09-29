import 'package:flutter/material.dart';

class Job {
  Job({required this.name, required this.ratePerHours});
  final String name;
  final int ratePerHours;

  Map<String, dynamic> toMap() {
    return {"name": name, "ratePerHours": ratePerHours};
  }

  factory Job.formMap(Map<String, dynamic> data) {
    final String name = data['name'];
    final int ratePerHours = data['ratePerHours'];
    return Job(name: name, ratePerHours: ratePerHours);
  }


}
