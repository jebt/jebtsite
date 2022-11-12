import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


void main() {
  runApp(const JebtSite());
}

class JebtSite extends StatelessWidget {
  const JebtSite({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JebtSite',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Jebt Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  late Future<String> _thoughts;
  String? _inspiringText;

  @override
  void initState() {
    super.initState();
    _thoughts = getThoughts();
  }

  Future<String> getThoughts() async {
    String result = await rootBundle.loadString('assets/shower_thoughts.txt');
    return result;
  }

  void _inspire() async {
    String allText = await getThoughts();
    List<String> lines = allText.split("\n");
    String line = "";
    while (line == "" || line == _inspiringText) {
      line = (lines..shuffle()).first;
    }
    setState(() => _inspiringText = line);
  }


  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     // _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SizedBox(
          width: 505,
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: _inspire, child: const Text("Inspire me!")),
                ),
              ),
              _inspiringText == null ? Container() :
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: SelectableText(_inspiringText??"", textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(height: 8.0,)
                ],
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  autoPlay: true
                ),
                items: [
                  const Image(image: AssetImage("images/bnt1.png")),
                  const Image(image: AssetImage("images/bnt2.png")),
                  const Image(image: AssetImage("images/bnt3.png")),
                  const Image(image: AssetImage("images/bnt4.png")),
                  FutureBuilder<String>(future: _thoughts, builder: (BuildContext context, AsyncSnapshot<String>
                      snapshot) {
                    if (snapshot.hasData) {
                      String? text = snapshot.data;
                      text ??= "null";
                      return Text(text);
                    } else {
                      return const Text("loading...");
                    }
                  })
                  ]
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: _launchURL, child: const Text('About Jebt')),
                ),
              ),
            ],
          ),
        )
      // Column(
        //   // Column is also a layout widget. It takes a list of children and
        //   // arranges them vertically. By default, it sizes itself to fit its
        //   // children horizontally, and tries to be as tall as its parent.
        //   //
        //   // Invoke "debug painting" (press "p" in the console, choose the
        //   // "Toggle Debug Paint" action from the Flutter Inspector in Android
        //   // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        //   // to see the wireframe for each widget.
        //   //
        //   // Column has various properties to control how it sizes itself and
        //   // how it positions its children. Here we use mainAxisAlignment to
        //   // center the children vertically; the main axis here is the vertical
        //   // axis because Columns are vertical (the cross axis would be
        //   // horizontal).
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       'You have pushed the button this many times:',
        //     ),
        //     Text(
        //       '$_counter',
        //       style: Theme.of(context).textTheme.headlineMedium,
        //     ),
        //   ],
        // ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _launchURL() async {
    Uri url = Uri(scheme: "https", host: "fietsieboy.art", path: "about.html");
    // 'https://flutter.dev'
    if (!await launchUrl(url)) throw 'Could not launch $url';
    // html.window.open('https://www.fluttercampus.com',"_self");
  }
}
