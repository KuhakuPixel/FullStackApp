import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:frontend/data_loader.dart';
import 'package:frontend/model.dart';
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

class AiSummaryPage extends StatelessWidget {
  String description;
  AiSummaryPage({required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Summary")),
      body: FutureBuilder<String>(
        future: DataLoader.aiSummary(description),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            // Handle the error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else {
            return Center(
              child: Column(
                children: [
                  Text("AI summary is loading, please wait"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  Product product;
  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("id: " + product.id.toString()),
              Text("price: \$ ${product.price}"),
              Text(
                "description:  ${product.description == null ? "no description available, no internet connection or server is down" : product.description}",
              ),
              Text("category:  ${product.category}"),
              Image.network("${product.imgUrl}?${product.id}"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => AiSummaryPage(
                        description: product.description == null
                            ? ""
                            : product.description!,
                      ),
                    ),
                  );
                },
                child: const Text('View AI Summary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
