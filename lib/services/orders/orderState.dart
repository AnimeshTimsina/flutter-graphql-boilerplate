import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:collection/collection.dart';

import 'model.dart';

class OrderState extends ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => this._orders;

  OrderState();

  int numberOfItemTypes() => _orders.length;

  void setOrder(
      {required Product product, required int quantity, String? description}) {
    OrderModel? selected =
        _orders.firstWhereOrNull((element) => element.product.id == product.id);
    if (selected != null) {
      _orders = _orders
          .map((e) => OrderModel(
              product: e.product,
              quantity:
                  e.product.id == selected.product.id ? quantity : e.quantity,
              orderDescription: e.product.id == selected.product.id
                  ? description
                  : e.orderDescription))
          .toList();
    } else {
      _orders.add(OrderModel(
          product: product, quantity: quantity, orderDescription: description));
    }
    notifyListeners();
  }

  void clearOrder() {
    _orders = [];
    notifyListeners();
  }

  void removeFromOrder({required Product product}) {
    _orders.removeWhere((e) => e.product == product);
    notifyListeners();
  }

  int getItemQuantity({required Product product}) {
    OrderModel? selected =
        _orders.firstWhereOrNull((element) => element.product.id == product.id);
    if (selected != null) {
      return selected.quantity;
    }
    return 0;
  }

  String? getItemDescription({required Product product}) {
    OrderModel? selected =
        _orders.firstWhereOrNull((element) => element.product.id == product.id);
    if (selected != null) {
      return selected.orderDescription;
    }
    return null;
  }

  double getTotalCartPrice() {
    double price = 0;
    _orders.forEach((element) {
      if (element.product.price != null) {
        price = price + (element.product.price! * element.quantity);
      }
    });
    return price;
  }

  String getTotalCartPriceAsFixedString() {
    double price = getTotalCartPrice();
    if (price % 1 != 0) {
      return price.toStringAsFixed(2);
    } else
      return price.toStringAsFixed(0);
  }

  setQuantity({required Product product, required int quantity}) {
    OrderModel? selected =
        _orders.firstWhereOrNull((element) => element.product.id == product.id);
    if (selected != null) {
      _orders = _orders
          .map((e) => OrderModel(
              product: product,
              quantity: e.product == product ? quantity : e.quantity))
          .toList();
      notifyListeners();
    }
  }

  increaseByQuantity({required Product product, int quantity = 1}) {
    _orders = _orders
        .map((e) => OrderModel(
            product: e.product,
            quantity:
                e.product == product ? (e.quantity + quantity) : e.quantity))
        .toList();
    notifyListeners();
  }

  decreaseByQuantity({required Product product, int quantity = 1}) {
    OrderModel? selected =
        _orders.firstWhereOrNull((element) => element.product == product);
    if (selected != null) {
      if (selected.quantity > 1) {
        _orders = _orders
            .map((e) => OrderModel(
                product: e.product,
                quantity: e.product == product
                    ? (e.quantity - quantity)
                    : e.quantity))
            .toList();
        notifyListeners();
      } else {
        _orders.removeWhere((e) => e.product == product);
        notifyListeners();
      }
      // notifyListeners();
    }
  }

  isCartEmpty() {
    return _orders.length == 0;
  }
}
