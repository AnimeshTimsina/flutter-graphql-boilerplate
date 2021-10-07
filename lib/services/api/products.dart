import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:omsnepal/graphql/custom_types/error.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:omsnepal/graphql/models/product_category.dart';
import 'package:omsnepal/graphql/queries/products.dart';
import 'package:http/http.dart' as http;
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/services/client.dart';

class ProductsAPI extends ChangeNotifier {
  List<ProductCategory>? _apiResponse;
  LoadingState? _loadingState;
  String? _errorMessage;

  LoadingState? get loadingState => this._loadingState;
  String? get errorMessage => this._errorMessage;
  List<ProductCategory>? get data => this._apiResponse;

  ProductsAPI({required String? accessToken}) {
    fetchData(accessToken: accessToken);
  }

  void fetchData({required String? accessToken}) async {
    if (true) {
      _loadingState = LoadingState.loading;
      notifyListeners();
    }

    Map payload = {"query": GQL_PRODUCTS_AND_CATEGORY_INFO};
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
        if (incoming["data"]["allProductCategories"] == null) {
          _loadingState = LoadingState.loaded;
          _apiResponse = null;
          notifyListeners();
        } else {
          try {
            List<ProductCategory> stats = List.generate(
                incoming["data"]["allProductCategories"].length,
                (index) => ProductCategory.fromJson(
                    incoming["data"]["allProductCategories"][index]));
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

  List<Product> getProductsByCategory({String? id, String? searchText}) {
    if (id != null) {
      //get products of a category
      List<Product>? all = _apiResponse?.firstWhere((e) => e.id == id).products;
      if (all == null || all.isEmpty) return [];
      return (searchText == null || searchText.isEmpty)
          ? all
          : all
              .where((e) =>
                  e.title!.toLowerCase().contains(searchText.toLowerCase()))
              .toList();
    }
    //get products of all categories
    List<Product> allProducts = [];
    _apiResponse?.forEach((e) {
      e.products?.forEach((element) {
        if (searchText == null || searchText.isEmpty)
          allProducts.add(element);
        else {
          if (element.title!.toLowerCase().contains(searchText.toLowerCase()))
            allProducts.add(element);
        }
      });
    });
    return allProducts;
  }
}
