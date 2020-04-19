import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/domain/rss_item.dart';

class Content extends StatefulWidget {
  final RssItem item;

  Content({Key key, @required this.item}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  SharedPreferences _sharedPreferences;
  int _fontSize = 24;

  loadSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _fontSize = _sharedPreferences.getInt('fontSize');
    if (_fontSize == null || _fontSize == 0) {
      _fontSize = 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPreferences();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.format_size),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 16,
                child: Text('16'),
              ),
              PopupMenuItem(
                value: 20,
                child: Text('20'),
              ),
              PopupMenuItem(
                value: 24,
                child: Text('24'),
              ),
              PopupMenuItem(
                value: 28,
                child: Text('28'),
              ),
              PopupMenuItem(
                value: 32,
                child: Text('32'),
              ),
            ],
            initialValue: _fontSize,
            onSelected: (value) => {
              _fontSize = value,
              _saveFontSize(_fontSize),
              setState(
                () {},
              ),
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Html(
          data: widget.item.description,
          customTextStyle: (node, baseStyle) {
            return baseStyle.merge(
              TextStyle(
                height: 2,
                fontSize: _fontSize * 1.0,
              ),
            );
          },
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _saveFontSize(int fontSize) async {
    await _sharedPreferences.setInt('fontSize', fontSize);
  }
}
