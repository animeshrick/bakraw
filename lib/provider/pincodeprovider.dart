import 'dart:convert';

import 'package:bakraw/backend.dart';
import 'package:bakraw/model/pincodemodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PincodeProvider with ChangeNotifier {
  List<PincodeModel> _items = [];

  List<PincodeModel> get items {
    return [..._items];
  }

  Future<PincodeModel> checkpincodestatus(String pincode) async {
    const url = '${Utility.BaseURL}${'/pin-codes.php?pincode='}';
    PincodeModel model;
    final response = await http.get('$url${pincode}');
    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      model = PincodeModel.fromJson(data);
    }

    return model;
  }
}
