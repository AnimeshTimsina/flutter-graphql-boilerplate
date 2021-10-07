import 'package:omsnepal/graphql/models/product.dart';

class ProductCategory {
  String? id;
  String? title;
  List<Product>? products;
  ProductCategory({this.id, this.title, this.products});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    products = json['products'] != null
        ? List.generate(json['products'].length,
            (index) => Product.fromJson(json['products'][index]))
        : null;
  }

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['title'] = title;
    data['products'] = products != null
        ? List.generate(
            products?.length ?? 0, (index) => products![index].toJson())
        : [];
    return data;
  }
}
