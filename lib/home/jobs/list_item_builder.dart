import 'package:demoflutter/home/jobs/empty_content_job.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T?>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T?>? items = snapshot.data;
      if (items!.isEmpty) {
        return const EmptyContent();
      } else {
        return _buildList(items);
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        message: "Can't load item right now",
        title: "something went wrong",
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T?> items) {
    return ListView.separated(
      // use when list very large
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) => index == 0 || index == items.length + 1
          ? Container()
          : itemBuilder(context, items[index - 1]!),
      itemCount: items.length + 2,
    );
  }
}
