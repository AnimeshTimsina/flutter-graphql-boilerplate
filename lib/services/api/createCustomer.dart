import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:omsnepal/graphql/custom_types/error.dart';
import 'package:omsnepal/graphql/models/customer.dart';
import 'package:omsnepal/graphql/mutations/createCustomer.dart';
import 'package:http/http.dart' as http;
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/services/client.dart';
import 'package:omsnepal/widgets/widgets.dart';

class CreateCustomerAPI extends ChangeNotifier {
  LoadingState? _createLoadingState;

  LoadingState? get createLoadingState => this._createLoadingState;

  CreateCustomerAPI();

  Future<Customer?> createNewCustomer(
      {required String accessToken,
      required CreateCustomerInput data,
      required BuildContext context}) async {
    _createLoadingState = LoadingState.loading;
    notifyListeners();

    Map payload = {"query": gqlCreateCustomer(data)};
    final Response? response = await http
        .post(
      Uri.parse(ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(payload),
    )
        .catchError((e) {
      if (e is SocketException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbar(text: "No internet connection"));
      }
      _createLoadingState = LoadingState.error;
      // if (onError is Exception)
      notifyListeners();
    });

    if (response?.body != null) {
      // print("RESPONSE BODY...........${response.body}");
      _createLoadingState = LoadingState.loaded;
      Map<String, dynamic> incoming = json.decode(response!.body);
      if (incoming["errors"] != null) {
        List<ErrorModel> errors = List.generate(incoming["errors"].length,
            (index) => ErrorModel.fromJson(incoming["errors"][index]));
        if (errors.length > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              snackbar(text: errors.first.message ?? '', color: Colors.red));
        }
        _createLoadingState = LoadingState.error;
        notifyListeners();
      } else {
        if (incoming["data"]["createCustomer"] == null) {
          _createLoadingState = LoadingState.loaded;
          ScaffoldMessenger.of(context).showSnackBar(
              snackbar(text: "Something went wrong", color: Colors.red));
          notifyListeners();
        } else
          try {
            Customer customer =
                Customer.fromJson(incoming["data"]["createCustomer"]);
            ScaffoldMessenger.of(context)
                .showSnackBar(snackbar(text: "Customer created successfully"));
            return customer;
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackbar(text: "Failed to cache!", color: Colors.red));
          } finally {
            _createLoadingState = LoadingState.loaded;
            notifyListeners();
          }
      }
      // notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          snackbar(text: "Something went wrong!", color: Colors.red));
      _createLoadingState = LoadingState.error;
      notifyListeners();
    }
  }
}
