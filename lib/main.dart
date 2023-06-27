import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFDFDFDE)
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  PageView(
        controller: controller,
        children: const[
        DetailPage(headline: "Today",daysInPast: 0),
        DetailPage(headline: "Yesterday",daysInPast: 1),
          DetailPage(headline: "before Yesterday",daysInPast: 2),
      ],)// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.headline, required this.daysInPast}) : super(key: key);

  final String headline;
  final int daysInPast;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 48, 0.0, 32.0),
      child: Column(children: [
        Text(widget.headline,style: const TextStyle(fontSize: 48.0, color: Colors.black,fontWeight: FontWeight.bold)),
        TrackingElement(color: const Color(0xFF3DCB53),iconData: Icons.directions_walk_sharp,unit:" m",max:5000,daysInPast: widget.daysInPast),
        TrackingElement(color: const Color(0xFF2F72AD),iconData: Icons.water_drop_outlined,unit:" ml",max: 3000,daysInPast: widget.daysInPast),
        TrackingElement(color: const Color(0xFF750505),iconData: Icons.no_food_outlined,unit:" kcal",max: 1680,daysInPast: widget.daysInPast),
      ],),
    );
  }
}


class TrackingElement extends StatefulWidget {
  const TrackingElement({Key? key, required this.color, required this.iconData, required this.unit, required this.max, required this.daysInPast}) : super(key: key);

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;
  final int daysInPast;

  @override
  _TrackingElementState createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _counter = 0;
  double _progress=0;
  var now= DateTime.now();
  String _storageKey ="";

  void _incrementCounter() async {
    setState(() {
      _counter+=200;
      _progress=_counter/widget.max;
    });
    (await _prefs).setInt(_storageKey, _counter);
  }

  @override
  void initState() {
    super.initState();
    _storageKey="${now.year}-${now.month}-${now.day - widget.daysInPast}_${widget.unit}";
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _prefs.then((prefs){
      setState(() {
        _counter =  prefs.getInt(_storageKey) ?? 0;
        _progress=_counter/widget.max;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _incrementCounter,
        child:Column(
        children: <Widget>[
        Padding(
          padding:const EdgeInsetsDirectional.fromSTEB(32.0, 64.0, 32.0, 24.0),
          child: Row(children: <Widget>[
            Icon(widget.iconData, color: Colors.black87,size:50),
            Text(
                " $_counter / ${widget.max.toInt()} ${widget.unit}",
                style: const TextStyle(color: Colors.black,fontSize: 18)
            ),
          ],),
        ),
        LinearProgressIndicator(
            value:_progress,
            color: widget.color,
            backgroundColor: const Color(0xFFCE8080),
            minHeight: 12.0
        ),
      ],
    ),);
  }
}

