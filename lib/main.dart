import 'dart:convert';
import 'aritcle_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kritik_app/Model/model.dart';
import 'dart:async';


String API_KEY = '4fa83f684b3a46fda8239f8a0f1654b7';
var currentValue = 'Business';
var categoriesOfData = ['Business', 'Entertainment', 'General', 'Sports','Technology'];

Future<List<Source>> fetchNewSource() async {
  final response =
  await http.get('https://newsapi.org/v2/sources?category=${currentValue}&language=en&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else {
    throw Exception('Failed to load source list');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>with TickerProviderStateMixin {
  var list_sources;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Business'),
    Tab(text: 'Entertainment'),
    Tab(text: 'General'),
    Tab(text: 'Sports'),
    Tab(text: 'Technology'),

  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    refreshListSource();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  //var refershKey = GlobleKey<RefreshIndicatorState>();
// I use different thing;;
  final GlobalKey<RefreshIndicatorState> refreshKey =
  new GlobalKey<RefreshIndicatorState>();



  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,

            onTap: (k){
              setState(() {

                currentValue= categoriesOfData[_tabController.index];
                refreshListSource();
                print(currentValue);
              });

            },
            tabs: myTabs,
          ),
          title: Text('News App'),
        ),
        body:
        TabBarView(
          controller: _tabController,

          children: myTabs.map((Tab tab) {
            final String label = tab.text.toLowerCase();
            return  Center(
              child: RefreshIndicator(
                  key: refreshKey,
                  child: FutureBuilder<List<Source>>(
                    future: list_sources,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<Source> source = snapshot.data;

                        return new ListView(
                          children: source
                              .map((source) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleScreen(source: source))
                              );
                            },
                            child: Card(
                              elevation: 1.0,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 14.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    width: 100.0,
                                    height: 140.0,
                                    child: Image.asset("assets/news.png"),
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
                                                    bottom: 10.0),
                                                child: Text(
                                                  '${source.name}',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Text(
                                            '${source.description}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                              .toList(),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  onRefresh: refreshListSource),
            );
          }).toList(),
        ),
      ),

    );





    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[

            ],
            title: Text('News App'),
          ),
          body: Center(
            child: RefreshIndicator(
                key: refreshKey,
                child: FutureBuilder<List<Source>>(
                  future: list_sources,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<Source> source = snapshot.data;

                      return new ListView(
                        children: source
                            .map((source) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ArticleScreen(source: source))
                            );
                          },
                          child: Card(
                            elevation: 1.0,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 14.0),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  width: 100.0,
                                  height: 140.0,
                                  child: Image.asset("assets/news.png"),
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
                                                  bottom: 10.0),
                                              child: Text(
                                                '${source.name}',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        child: Text(
                                          '${source.description}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                onRefresh: refreshListSource),
          ),
        ));
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewSource();
    });
  }
}
