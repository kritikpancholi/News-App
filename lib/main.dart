import 'dart:convert';
import 'aritcle_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kritik_app/Model/model.dart';
import 'dart:async';


String API_KEY = '4fa83f684b3a46fda8239f8a0f1654b7';        //This is to test if its working.
var currentValue = 'Business';
var categoriesOfData = ['Business', 'Entertainment', 'General', 'Sports','Technology'];       //This is to test if its working.

Future<List<Source>> fetchNewSource() async {
  final response =
  await http.get('https://newsapi.org/v2/sources?category=${currentValue}&language=en&apiKey=${API_KEY}');       //This is to test if its working.

  if (response.statusCode == 200) {                                                                    //This is to test if its working.
    List sources = json.decode(response.body)['sources'];                                             //This is to test if its working.
    return sources.map((source) => new Source.fromJson(source)).toList();                          //This is to test if its working.
  } else {                                                                                     //This is to test if its working.
    throw Exception('Failed to load source list');                                         //This is to test if its working.
  }                                                                                            //This is to test if its working.
}                                                                                       //This is to test if its working.
                                                                                      //This is to test if its working.
void main() => runApp(MyApp());                                                             //This is to test if its working.
                                                                          //This is to test if its working.
class MyApp extends StatefulWidget {                     //This is to test if its working.
  @override						//This is to test if its working.
  _MyAppState createState() => _MyAppState();            //This is to test if its working.
}                                                    //This is to test if its working.
                                                        //This is to test if its working.
class _MyAppState extends State<MyApp>with TickerProviderStateMixin {           //This is to test if its working.
  var list_sources;                                                     //This is to test if its working.
  final List<Tab> myTabs = <Tab>[                                   //This is to test if its working.
    Tab(text: 'Business'),                                       //This is to test if its working.
    Tab(text: 'Entertainment'),                                 //This is to test if its working.
    Tab(text: 'General'),                                   //This is to test if its working.
    Tab(text: 'Sports'),                                //This is to test if its working.
    Tab(text: 'Technology'),                             //This is to test if its working.
                                                      //This is to test if its working.
  ];                                                    //This is to test if its working.
                                                     //This is to test if its working.
  TabController _tabController;                        //This is to test if its working.
                                                      //This is to test if its working.
  @override                                         //This is to test if its working.
  void initState() {                                  //This is to test if its working.
    super.initState();                                   //This is to test if its working.
    refreshListSource();                               //This is to test if its working.
    _tabController = TabController(vsync: this, length: myTabs.length);         //This is to test if its working.
  }                                                   //This is to test if its working.
                                                                                             //This is to test if its working.
  @override                                           //This is to test if its working.
  void dispose() {                                   //This is to test if its working.
    _tabController.dispose();                           //This is to test if its working.
    super.dispose();                                       //This is to test if its working.
  }                                              //This is to test if its working.
                                                //This is to test if its working.
                                                 //This is to test if its working.
  //var refershKey = GlobleKey<RefreshIndicatorState>();                
// I use different thing;;
  final GlobalKey<RefreshIndicatorState> refreshKey =
  new GlobalKey<RefreshIndicatorState>();
  
                                                     //This is to test if its working.
                                                 //This is to test if its working.
						//This is to test if its working.
                                                 //This is to test if its working.
                                               //This is to test if its working.
                                                 //This is to test if its working.
                                               //This is to test if its working.
                                                 //This is to test if its working.
                                              //This is to test if its working.
                                                 //This is to test if its working.
 

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
