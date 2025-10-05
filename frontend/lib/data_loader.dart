import 'dart:math';

import 'package:frontend/model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class LoadedData {
  List<Product> datas;
  int pageCount;
  LoadedData(this.datas, this.pageCount);
}

class DataLoader {
  // Define the base URI, including the port
  static final String host = '192.168.1.9';
  static final int port = 3000;
  static Database? database = null;
  static Future<List<String>> fetchCategories() async {
    // Construct the URI with query parameters
    final uri = Uri(
      scheme: 'http',
      host: host,
      port: port,
      path: "/categories",
    );

    // Send the GET request
    final response = await http.get(uri);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON body
      final List<dynamic> dataDynamic = json.decode(response.body);

      return dataDynamic.cast<String>();
    } else {
      // Handle non-200 status codes
      throw new Exception(
        'Failed to fetch data. Status code: ${response.statusCode}',
      );
    }
  }

  static Future<Product> fetchProduct(int id) async {
    var productResult = (await database!.rawQuery(
      "SELECT * FROM products WHERE id = ${id}",
    )).first;
    var product = Product.fromMap(productResult);
    // try to fetch from network
    if (product.description == null) {
      // Construct the URI with query parameters
      final uri = Uri(
        scheme: 'http',
        host: host,
        port: port,
        path: "/products/${id}",
      );
      // TODO: save product detail to db

      try {
        print('Attempting to fetch data from: $uri');
        // Send the GET request
        final response = await http.get(uri);
        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          // Decode the JSON body
          final Map<String, dynamic> data = json.decode(response.body);
          await database!.insert(
            'products',
            data,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          return Product.fromMap(data);
        } else {
          return product;
        }
      } catch (e) {
        // just return the current product if we are unable to connect to the internet
        return product;
      }
    }
    return product;
  }

  // TODO: how to return page count?
  static Future<LoadedData> fetchProductsFromDB(
    Database database,
    int page,
    int limit, {
    required String category,
    required String search,
  }) async {
    var resultList = await database.rawQuery(
      "SELECT id, name, price, description, category, img_url FROM products;",
    );

    var whereClause = "WHERE name LIKE '%${search}%'";
    if (category != "") {
      whereClause += " AND category = '${category}'";
    }
    var resultListPaginated = await database.rawQuery(
      "SELECT id, name, price, description, category, img_url FROM products ${whereClause} ORDER BY ID LIMIT ${limit} OFFSET ${(page - 1) * limit};",
    );

    List<Product> productsPaginated = [];
    for (var result in resultListPaginated) {
      productsPaginated.add(Product.fromMap(result));
    }
    return LoadedData(productsPaginated, (resultList.length / limit).ceil());
  }

  static Future<LoadedData> fetchProducts(
    int page,
    int limit, {
    required String category,
    required String search,
  }) async {
    final String path = '/products';
    List<Product> products = [];

    // Open the database and store the reference.
    // ignore: prefer_conditional_assignment
    if (database == null) {
      database = await openDatabase(
        join(await getDatabasesPath(), 'data.db'),
        // When the database is first created, create a table to store data.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE products (id INT PRIMARY KEY, name TEXT, price INT, description TEXT, category TEXT, img_url TEXT);',
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }
    List<Product> productsLoadedFromNetwork;
    int pageCountFromNetwork = 0;
    // load from offline storage
    var productsLoadedFromDb = await fetchProductsFromDB(
      database!,
      page,
      limit,
      category: category,
      search: search,
    );
    products.addAll(productsLoadedFromDb.datas);
    var idsToExclude = productsLoadedFromDb.datas.map((e) => e.id).toList();

    // TODO: check if I should perform a network request?
    // get request to fetch item
    try {
      // Construct the URI with query parameters
      final uri = Uri(
        scheme: 'http',
        host: host,
        port: port,
        path: path,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          "search": search,
          "category": category,
          "exclude_ids": idsToExclude.toString(),
        },
      );
      print('Attempting to fetch data from: $uri');
      final response = await http.get(uri);
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Successfully fetched products (Status: 200)');

        // Decode the JSON body
        final Map<String, dynamic> data = json.decode(response.body);
        pageCountFromNetwork = data["page_count"];
        List<dynamic> products_dynamic = data["products"];
        productsLoadedFromNetwork = products_dynamic
            .map(
              (element) => Product(
                category: element["category"],
                description:
                    null, // description isn't available when getting a product list so we set it to null
                id: element["id"],
                imgUrl: element["img_url"],
                name: element["name"],
                price: element["price"],
              ),
            )
            .toList();

        products.addAll(productsLoadedFromNetwork);
        // save network result to db
        for (var p in productsLoadedFromNetwork) {
          await database!.insert(
            'products',
            p.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        print(
          "saved ${productsLoadedFromNetwork.length} items to offline storage",
        );
      } else {
        return LoadedData([], 0);
        // Handle non-200 status codes
        /*
      throw new Exception(
        'Failed to fetch datas. Status code: ${response.statusCode}',
      );
      */
      }
    } catch (e) {}
    int pageCount = max(productsLoadedFromDb.pageCount, pageCountFromNetwork);
    return LoadedData(products, pageCount);
  }
}
