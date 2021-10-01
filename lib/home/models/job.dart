class Job {
  Job({required this.id, required this.name, required this.ratePerHours});
  final String name;
  final int ratePerHours;
  final String id;
  Map<String, dynamic> toMap() {
    return {"name": name, "ratePerHours": ratePerHours};
  }

  factory Job.formMap(Map<String, dynamic> data, String documentID) {
    final String name = data['name'];
    final int ratePerHours = data['ratePerHours'];
    return Job(name: name, ratePerHours: ratePerHours, id: documentID);
  }
}
