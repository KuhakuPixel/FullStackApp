import 'dart:async';

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
  static Timer? debounce = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LoadedData>(
        future: DataLoader.fetchProducts(
          context.watch<AppStateProvider>().page,
          search: context.watch<AppStateProvider>().search,
          category: context.watch<AppStateProvider>().category,
          PAGE_LIMIT,
        ),
        builder: (BuildContext context, AsyncSnapshot<LoadedData> snapshot) {
          if (snapshot.hasError) {
            // Handle the error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // load page count and the data
            Widget searchResultWidget;
            if (snapshot.data!.datas.length > 0) {
              searchResultWidget = ListView(
                children: snapshot.data!.datas
                    .map(
                      (data) => SearchResultWidget(
                        data.name,
                        data.price,
                        data.category,
                        onViewDetail: () async {
                          var p = await DataLoader.fetchProduct(data.id);
                          print(p);

                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => ProductDetailPage(product:p),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              );
            } else {
              searchResultWidget = Center(child: Text('No Result'));
            }
            return Column(
              children: [
                SizedBox(height: 50),

                MyPageController(
                  currentPage: context.watch<AppStateProvider>().page,
                  pageCount: snapshot.data!.pageCount,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                  onChanged: (value) {
                    if (debounce != null) {
                      if (debounce!.isActive) {
                        debounce!.cancel();
                      }
                    }
                    debounce = Timer(
                      new Duration(milliseconds: SEARCH_FILTER_DEBOUNCE_MS),
                      () {
                        context.read<AppStateProvider>().setSearch(value);
                        // every time a filter change reset current page to one
                        context.read<AppStateProvider>().setPage(1);
                      },
                    );
                  },
                ),

                DropdownButton<String>(
                  value: context.watch<AppStateProvider>().category,
                  items: BOOK_CATEGORIES.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (category) {
                    context.read<AppStateProvider>().setCategory(category!);
                    // every time a filter change reset current page to one
                    context.read<AppStateProvider>().setPage(1);
                  },
                ),
                /*
                CategoryDropDown(
                  onSelected: (category) {
                    context.read<AppStateProvider>().setCategory(category!);
                    // every time a filter change reset current page to one
                    context.read<AppStateProvider>().setPage(1);
                  },
                  value: context.watch<AppStateProvider>().category!,
                ),
                */
                Expanded(child: searchResultWidget),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
