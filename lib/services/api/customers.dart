import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:omsnepal/graphql/custom_types/error.dart';
import 'package:omsnepal/graphql/models/customer.dart';
import 'package:omsnepal/graphql/queries/customers.dart';
import 'package:http/http.dart' as http;
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/services/client.dart';

class CustomersAPI extends ChangeNotifier {
  List<Customer>? _apiResponse;
  LoadingState? _loadingState;
  String? _errorMessage;

  LoadingState? get loadingState => this._loadingState;
  String? get errorMessage => this._errorMessage;
  List<Customer>? get data => this._apiResponse;

  CustomersAPI({required String? accessToken}) {
    fetchData(accessToken: accessToken);
  }

  void fetchData({required String? accessToken}) async {
    if (true) {
      _loadingState = LoadingState.loading;
      notifyListeners();
    }

    Map payload = {"query": GQL_CUSTOMERS};
    final Response? response = await http
        .post(
      Uri.parse(ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'JWT $accessToken'
      },
      body: jsonEncode(payload),
    )
        .catchError((onError) {
      _loadingState = LoadingState.error;
      notifyListeners();
    });

    if (response?.body != null) {
      _loadingState = LoadingState.loaded;
      Map<String, dynamic> incoming = json.decode(response!.body);
      if (incoming["errors"] != null) {
        List<ErrorModel> errors = List.generate(incoming["errors"].length,
            (index) => ErrorModel.fromJson(incoming["errors"][index]));
        if (errors.length > 0) {
          _errorMessage = errors.first.message;
        } else {
          _errorMessage = null;
        }
        _loadingState = LoadingState.error;
        notifyListeners();
      } else {
        if (incoming["data"]["allCustomers"] == null) {
          _loadingState = LoadingState.loaded;
          _apiResponse = null;
          notifyListeners();
        } else {
          try {
            List<Customer> stats = List.generate(
                incoming["data"]["allCustomers"].length,
                (index) =>
                    Customer.fromJson(incoming["data"]["allCustomers"][index]));
            _apiResponse = stats;
            _loadingState = LoadingState.loaded;
          } catch (error) {
            _loadingState = LoadingState.error;
            _errorMessage = null;
          } finally {
            notifyListeners();
          }
        }
      }
    } else {
      _loadingState = LoadingState.error;
      _errorMessage = null;
      notifyListeners();
    }
  }

  List<Customer> getFilteredCustomers(String? query) {
    if (_apiResponse == null) return [];
    if (query == null || query == "") return _apiResponse!;
    return _apiResponse!
        .where((element) =>
                element.fullName.toLowerCase().contains(query.toLowerCase()) ||
                (element.phone != null && element.phone!.contains(query)) ||
                (element.vat != null && element.vat!.toString().contains(query))
            // ||  (element.address != null && element.address!.contains(query))
            )
        .toList();
  }
}
