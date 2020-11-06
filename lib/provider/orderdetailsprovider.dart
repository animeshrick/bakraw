import 'dart:convert';

import 'package:bakraw/backend.dart';
import 'package:bakraw/model/orderdetailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetailsProvider with ChangeNotifier {
  List<OrderDetailsModel> _items = [];

  List<OrderDetailsModel> get items {
    return [..._items];
  }

  Future<OrderDetailsModel> getOrderDetail(
      String apikey, String userid, String email, String orderid) async {
    const url = '${Utility.BaseURL}${'order-details.php'}';

    OrderDetailsModel model;
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'apikey': apikey},
        body: jsonEncode({
          'user_id': userid,
          'user_email': email,
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodeddata = jsonDecode(response.body);
      model = OrderDetailsModel.fromJson(decodeddata);
    }

    return model;
  }
}