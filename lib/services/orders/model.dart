import 'package:omsnepal/graphql/models/product.dart';

class OrderModel {
  final Product product;
  final int quantity;
  final String? orderDescription;

  OrderModel(
      {required this.product, required this.quantity, this.orderDescription});
}
