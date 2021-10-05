import 'package:demoflutter/home/account/account_page.dart';
import 'package:demoflutter/home/cupertino_home_scaffold.dart';
import 'package:demoflutter/home/jobs/jobs_page.dart';
import 'package:demoflutter/home/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JopsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorkeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorkeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorkeys: navigatorkeys,
      ),
    );
  }

  void _select(TabItem tabItem) {
    // print(tabItem);
    setState(() {
      _currentTab = tabItem;
    });
  }
}
