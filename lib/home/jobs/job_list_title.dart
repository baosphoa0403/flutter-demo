import 'package:demoflutter/home/models/job.dart';
import 'package:flutter/material.dart';

class JobListTitle extends StatelessWidget {
  const JobListTitle({Key? key, required this.job, required this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name + "- " + job.ratePerHours.toString()),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
