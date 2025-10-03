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

  SearchResultWidget(this.name, this.price, this.category);

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
            OutlinedButton(onPressed: () {}, child: Text("View Detail")),
          ],
        ),
      ),
    );
  }
}
