import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadedData {
  List<dynamic> datas;
  int pageCount;
  LoadedData(this.datas, this.pageCount);
}

class DataLoader {
  static Future<LoadedData> fetchData(int page, int limit) async {
    // Define the base URI, including the port
    final String host = 'localhost';
    final int port = 3000;
    final String path = '/products';

    // Construct the URI with query parameters
    final uri = Uri(
      scheme: 'http',
      host: host,
      port: port,
      path: path,
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );

    print('Attempting to fetch data from: $uri');

    // Send the GET request
    final response = await http.get(uri);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      print('Successfully fetched products (Status: 200)');

      // Decode the JSON body
      final Map<String, dynamic> data = json.decode(response.body);
      try {

        int page_count = data["page_count"];
        List<dynamic> products = data["products"];
        var loadedData = LoadedData(products, page_count);
        return loadedData;
      } catch (e) {
        throw e;
      }
    } else {
      // Handle non-200 status codes
      throw new Exception(
        'Failed to fetch datas. Status code: ${response.statusCode}',
      );
    }
  }
}
