import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Animation',
      theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
              display1: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TitilliumWeb',
                  fontSize: 60,
                  shadows: [
                Shadow(
                    color: Colors.blueGrey,
                    blurRadius: 1.5,
                    offset: Offset(1, 1))
              ]))),
      home: MyHomePage(title: 'Flutter Demo Animation Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _opacityController;
  Animation<double> _opacity;
  Animation<RelativeRect> _positionAnimation;
  AnimationController _positionController;

  bool _cardDisplayed = false;
  double opacityLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    _opacity = CurvedAnimation(parent: _opacityController, curve: Curves.linear)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _opacityController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _opacityController.forward();
        }
      });

    _opacityController.forward();

    _positionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _positionAnimation = RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, -1500.0, 0.0, 0.0),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_positionController);

    _positionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.setState(() {
          _cardDisplayed = true;
        });
      } else {
        _cardDisplayed = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _opacityController.dispose();
    _positionController.dispose();
  }

  void _showHiddenCard() {
    if (!_cardDisplayed) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text("message".toUpperCase(),
                        style: TextStyle(
                            color: Colors.blueGrey.withAlpha(180),
                            letterSpacing: 10),
                        textAlign: TextAlign.center),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                // Box decoration takes a gradient
                                gradient: LinearGradient(
                                    // Where the linear gradient begins and ends
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    // Add one stop for each color. Stops should increase from 0 to 1
                                    stops: [
                                      0.1,
                                      0.3,
                                      0.6,
                                      0.9
                                    ],
                                    colors: [
                                      Colors.blueGrey.withAlpha(100),
                                      Colors.blueGrey.withAlpha(80),
                                      Colors.white.withAlpha(50),
                                      Colors.white,
                                    ])),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.8,
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 20,
                                        bottom: 10),
                                    child: Text(
                                      "This is how i do it.",
                                      style: TextStyle(height: 1.5),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 20,
                                        bottom: 10),
                                    child: Text(
                                      "Touch anywhere to hide me.",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            )))),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          PositionedTransition(
            rect: _positionAnimation,
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: screenSize.height * 0.5,
                  width: screenSize.width * 0.7,
                  child: Card(
                    color: _cardDisplayed
                        ? Colors.white
                        : Colors.blueAccent.withAlpha(180),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(30)),
                    child: Opacity(
                        opacity: 1.0,
                        child: FadeTransition(
                          opacity: _opacity,
                          child: Container(
                            height: screenSize.height * 0.5,
                            width: screenSize.width * 0.7,
                            decoration: ShapeDecoration(
                                color: Colors.blueAccent.withAlpha(180),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(30),
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: FadeAnimatedTextKit(
                                  duration: Duration(milliseconds: 5000),
                                  isRepeatingAnimation: true,
                                  text: [
                                    "Hi Flutter!",
                                    "\nLet's",
                                    "\n\n\ndo it!!!"
                                  ],
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                )),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[300],
              onPressed: () => _showBottomSheet(context),
              tooltip: 'Say something...',
              child: Icon(Icons.announcement),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _showHiddenCard,
              tooltip: 'Get your card',
              child: Icon(!_cardDisplayed
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
