import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:frontend/consts.dart';
import 'package:frontend/data_loader.dart';
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
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark,

        title: 'Flutter Demo',
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
  List<Map<String, dynamic>> datas = [
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyPageController(),
          FutureBuilder<LoadedData>(
            future: DataLoader.fetchData(
              context.watch<AppStateProvider>().page,
              PAGE_LIMIT,
            ),
            builder:
                (BuildContext context, AsyncSnapshot<LoadedData> snapshot) {
                  if (snapshot.hasError) {
                    // Handle the error state
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // load page count and the data
                    context.read<AppStateProvider>().setPageCount(snapshot.data!.pageCount);
                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.datas
                            .map(
                              (data) => SearchResultWidget(
                                data["name"],
                                data["price"],
                                data["category"],
                              ),
                            )
                            .toList(),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
          ),
        ],
      ),
    );
  }
}
