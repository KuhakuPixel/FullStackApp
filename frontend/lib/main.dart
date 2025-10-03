import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:frontend/my_widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyPageController(),
          Expanded(child:ListView(children: [
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
            Text("hi hi hi"),
          ],))
        ],
      ),
    );
  }
}
