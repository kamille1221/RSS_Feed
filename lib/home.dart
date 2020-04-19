import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rss_feed/content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class RSSReader extends StatefulWidget {
  RSSReader() : super();

  final String title = 'flutter RSS feed';

  @override
  RSSReaderState createState() => RSSReaderState();
}

class RSSReaderState extends State<RSSReader> {
  SharedPreferences _sharedPreferences;
  String _feedUrl = 'http://myhome.chosun.com/rss/www_section_rss.xml';
  RssFeed _feed;
  String _title;
  int _fontSize = 24;
  ScrollController _controller = ScrollController();

  static const String loadingMessage = 'Loading Feed...';
  static const String feedLoadErrorMessage = 'Error Loading Feed';
  static const String feedOpenErrorMessage = 'Error Opening Feed';

  GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(RssItem item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Content(item: item),
      ),
    );
  }

  load() async {
    updateTitle(loadingMessage);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMessage);
        return;
      }
      updateFeed(result);
      updateTitle("Flutter RSS feed");
    });
  }

  Future<RssFeed> loadFeed() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _feedUrl = _sharedPreferences.getString('feedUrl');
    if(_feedUrl == null || _feedUrl.isEmpty) {
      _feedUrl = 'http://myhome.chosun.com/rss/www_section_rss.xml';
    }
    _fontSize = _sharedPreferences.getInt('fontSize');
    if(_fontSize == null || _fontSize == 0) {
      _fontSize = 24;
    }
    try {
      final client = http.Client();
      final response = await client.get(_feedUrl);
      return RssFeed.parse(utf8.decode(response.bodyBytes));
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.find_replace),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'http://myhome.chosun.com/rss/www_section_rss.xml',
                child: Text('조선일보'),
              ),
              PopupMenuItem(
                value: 'https://rss.joins.com/joins_homenews_list.xml',
                child: Text('중앙일보'),
              ),
            ],
            initialValue: _feedUrl,
            onSelected: (value) => {
              _feedUrl = value,
              load(),
              _saveFeedUrl(_feedUrl),
            },
          ),
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
              updateFeed(_feed),
              _saveFontSize(_fontSize),
            },
          ),
        ],
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.ease),
        child: Icon(Icons.vertical_align_top),
        foregroundColor: Colors.white,
        mini: false,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  list() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            child: ListView.builder(
              controller: _controller,
              padding: EdgeInsets.all(8.0),
              itemCount: _feed.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _feed.items[index];
                return Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: _fontSize * 1.0,
                          // fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 32.0,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.all(8.0),
                      onTap: () => openFeed(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _saveFeedUrl(String feedUrl) async {
    await _sharedPreferences.setString('feedUrl', feedUrl);
  }

  _saveFontSize(int fontSize) async {
    await _sharedPreferences.setInt('fontSize', fontSize);
  }
}
