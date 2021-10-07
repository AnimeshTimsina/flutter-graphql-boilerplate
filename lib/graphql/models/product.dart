import 'package:omsnepal/graphql/models/product_category.dart';

class Product {
  String? id;
  String? title;
  String? description;
  double? price;
  ProductCategory? category;
  String? photo;
  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.category,
      this.photo});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'] != null ? json["price"].toDouble() : null;
    category = json['category'] != null
        ? ProductCategory.fromJson(json['category'])
        : null;
    photo = json['photo'];
  }

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['category'] = category?.toJson();
    data['photo'] = photo;
    return data;
  }
}
