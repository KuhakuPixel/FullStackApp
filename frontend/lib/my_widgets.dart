import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:provider/provider.dart';

class MyPageController extends StatelessWidget {
  int pageCount = 0;
  MyPageController(this.pageCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: context.watch<AppStateProvider>().page == 1
              ? null
              : () {
                  context.read<AppStateProvider>().incrementPage(-1);
                },
          icon: Icon(Icons.arrow_back),
        ),
        Spacer(),
        Text("page ${context.watch<AppStateProvider>().page} / ${pageCount} "),
        Spacer(),
        IconButton(
          onPressed: (context.watch<AppStateProvider>().page == pageCount)
              ? null
              : () {
                  context.read<AppStateProvider>().incrementPage(1);
                },
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  final String name;
  final int price;
  final String category;
  final VoidCallback onViewDetail;

  SearchResultWidget(
    this.name,
    this.price,
    this.category, {
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(name), Text("\$ ${price}"), Text(category)],
            ),
            Spacer(),
            OutlinedButton(onPressed: onViewDetail, child: Text("View Detail")),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  int id;
  String name;
  int price;
  String description;
  String category;
  String img_url;
  ProductDetailPage({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.img_url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("id " + id.toString()),
              Text("price: \$ ${price}"),
              Text("description:  ${description}"),
              Text("category:  ${category}"),
              Image.network(
                "${img_url}?${DateTime.now().millisecondsSinceEpoch.toString()}",
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to first route when tapped.
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
