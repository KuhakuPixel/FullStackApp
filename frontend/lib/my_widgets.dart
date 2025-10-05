import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:frontend/data_loader.dart';
import 'package:provider/provider.dart';

class CategoryDropDown extends StatelessWidget {
  void Function(String?) onSelected;
  String value;
  CategoryDropDown({required this.onSelected, required this.value});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataLoader.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Handle the error state
          return Center(
            child: Text(
              'cannot fetch categories due to offline, need to be online first to download it: ${snapshot.error}',
            ),
          );
        } else if (snapshot.hasData) {
          //return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Search ...',
                ),
              ),

              */
              DropdownButton<String>(
                value: value,
                items: snapshot.data!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  // TODO add callback
                  onSelected(value);
                },
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    ;
  }
}

class MyPageController extends StatelessWidget {
  int pageCount = 0;
  int currentPage = 1;
  MyPageController({required this.currentPage, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: currentPage <= 1
              ? null
              : () {
                  context.read<AppStateProvider>().incrementPage(-1);
                },
          icon: Icon(Icons.arrow_back),
        ),
        Spacer(),
        Text("page ${currentPage} / ${pageCount} "),
        Spacer(),
        IconButton(
          onPressed: (currentPage >= pageCount)
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
                "${img_url}?${id}",
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
