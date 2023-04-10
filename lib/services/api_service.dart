import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/product_model.dart';

//Get products depending on the limit and skip
getProductsWithLimit(int limit, int skip) async {
  try {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}?limit=${limit}&skip=${skip}&select=title,price,thumbnail,stock,discountPercentage",
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    }
    return;
    throw Exception('Request API Failed');
  } catch (e) {
    throw Exception('Request API Failed');
  }
}

//Get single product to display more info
Future<ProductModel> getSingleProduct(int productId) async {
  try {
    var url = Uri.parse(ApiConstants.baseUrl + '${productId}');
    var response = await http.get(url);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Request API Failed');
    }
  } catch (e) {
    throw Exception('Request API Failed');
  }
}
