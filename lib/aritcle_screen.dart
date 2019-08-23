import 'package:kritik_app/Model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:kritik_app/WebView.dart';


String API_KEY = '4fa83f684b3a46fda8239f8a0f1654b7';

Future<List<Article>> fetchArticleBtSource(String source) async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load article list');
  }
}

class ArticleScreen extends StatefulWidget {
  final Source source;

  ArticleScreen({Key key, @required this.source})
      : super(key: key); // Have to get this things Knowe////////////////

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  var list_articles;

  final GlobalKey<RefreshIndicatorState> refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListArticle();
  }

  Future<Null> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchArticleBtSource(widget.source.id);
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Articles',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.source.name),
        ),
        body: Center(
          child: RefreshIndicator(
              key: refreshKey,
              child: FutureBuilder<List<Article>>(
                future: list_articles,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Article> article = snapshot.data;
                    return ListView(
                        children: article
                            .map((article) => GestureDetector(
                                  onTap: () {
                                    // _launchUrl(article.url);
                                    _handleURLButtonPress(context, article.url);
                                  },
                                  child: Card(
                                    elevation: 1.0,
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 4.0),
                                          height: 140.0,
                                          width: 100.0,
                                          child: article.urlToImage != null
                                              ? Image.network(
                                                  article.urlToImage)
                                              : Image.asset('assets/news.png'),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20.0,
                                                          left: 2.0,
                                                          bottom: 10.0),
                                                      child: Text(
                                                        '${article.title}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  '${article.description}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Published At: ${article.publishedAt}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.share),
                                                onPressed: (){
                                                  Share.share(article.url);
                                                },

                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList());
                  }
                  return CircularProgressIndicator();
                },
              ),
              onRefresh: refreshListArticle),
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch ${url}');
    }
  }
}
