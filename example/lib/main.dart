import 'package:flutter/material.dart';
import 'package:futuristic/futuristic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        GoodScreen.routeName: (_) => GoodScreen(),
        BadScreen.routeName: (_) => BadScreen(),
      },
    );
  }
}

/// A future that completes successfully.
Future<int> goodFuture(int first, int second) async {
  await Future.delayed(const Duration(seconds: 1));
  return first + second;
}

// A future that completes with an exception.
Future<int> badFuture(int first, int second) async {
  await Future.delayed(const Duration(seconds: 1));
  throw Exception('Something happened');
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(height: 50, child: Center(child: GoodButton())),
            Container(height: 50, child: Center(child: BadButton())),
            RaisedButton(
              child: Text('Good screen example'),
              onPressed: () {
                Navigator.of(context).pushNamed(GoodScreen.routeName);
              },
            ),
            RaisedButton(
              child: Text('Bad screen example'),
              onPressed: () {
                Navigator.of(context).pushNamed(BadScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}

class GoodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Futuristic<int>(
      futureBuilder: () => goodFuture(1, 2),
      initialBuilder: (_, start) =>
          RaisedButton(child: Text('Good button example'), onPressed: start),
      busyBuilder: (_) => CircularProgressIndicator(),
      dataBuilder: (_, data) => Text(data.toString()),
    );
  }
}

class BadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Futuristic<int>(
      futureBuilder: () => badFuture(1, 2),
      initialBuilder: (_, start) =>
          RaisedButton(child: Text('Bad button example'), onPressed: start),
      busyBuilder: (_) => CircularProgressIndicator(),
      errorBuilder: (_, error, retry) =>
          RaisedButton(child: Text('Sorry! Try again'), onPressed: retry),
    );
  }
}

class GoodScreen extends StatelessWidget {
  static const routeName = '/good';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Good screen')),
      body: Center(
        child: Futuristic<int>(
          autoStart: true,
          futureBuilder: () => goodFuture(1, 2),
          busyBuilder: (_) => CircularProgressIndicator(),
          dataBuilder: (_, data) => Text('Data is $data'),
        ),
      ),
    );
  }
}

class BadScreen extends StatelessWidget {
  static const routeName = '/bad';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bad screen')),
      body: Center(
        child: Futuristic<int>(
          autoStart: true,
          futureBuilder: () => badFuture(1, 2),
          busyBuilder: (_) => CircularProgressIndicator(),
          onError: (error, retry) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Sorry! Try again'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('RETRY'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      retry();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
