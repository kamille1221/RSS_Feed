import 'package:flutter/material.dart';
import 'package:rss_feed/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RSS feed',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.green[300],
        highlightColor: Colors.green[100],
      ),
      home: RSSReader(),
    );
  }
}
