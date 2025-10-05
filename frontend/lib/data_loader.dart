import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadedData {
  List<dynamic> datas;
  int pageCount;
  LoadedData(this.datas, this.pageCount);
}

class DataLoader {
  // Define the base URI, including the port
  static final String host = '192.168.1.9';
  static final int port = 3000;
  // TODO: provide offline support
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

  static Future<Map<String, dynamic>> fetchProduct(int id) async {
    // Construct the URI with query parameters
    final uri = Uri(
      scheme: 'http',
      host: host,
      port: port,
      path: "/products/${id}",
    );

    print('Attempting to fetch data from: $uri');

    // Send the GET request
    final response = await http.get(uri);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON body
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Handle non-200 status codes
      throw new Exception(
        'Failed to fetch data. Status code: ${response.statusCode}',
      );
    }
  }

  static Future<LoadedData> fetchProducts(
    int page,
    int limit, {
    required String category,
    required String search,
  }) async {
    final String path = '/products';

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
      },
    );

    print('Attempting to fetch data from: $uri');

    try {
      // Send the GET request
      final response = await http.get(uri);
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Successfully fetched products (Status: 200)');

        // Decode the JSON body
        final Map<String, dynamic> data = json.decode(response.body);
        int page_count = data["page_count"];
        List<dynamic> products = data["products"];
        var loadedData = LoadedData(products, page_count);
        return loadedData;
      } else {
        return LoadedData([], 0);
        // Handle non-200 status codes
        /*
      throw new Exception(
        'Failed to fetch datas. Status code: ${response.statusCode}',
      );
      */
      }
    } catch (e) {
        return LoadedData([], 0);
    }
  }
}
