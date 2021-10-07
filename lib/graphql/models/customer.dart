import 'package:omsnepal/graphql/models/user.dart';

class Customer {
  late String id;
  late String fullName;
  String? phone;
  String? address;
  int? vat;
  String? description;
  User? createdBy;
  late DateTime createdAt;
  late DateTime updatedAt;
  Customer(
      {required this.id,
      required this.fullName,
      this.phone,
      this.address,
      this.vat,
      this.description,
      this.createdBy,
      required this.createdAt,
      required this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phone = json['phone'];
    address = json['address'];
    vat = json['vat'];
    description = json['description'];
    createdBy =
        json['createdBy'] != null ? User.fromJson(json['createdBy']) : null;
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['address'] = address;
    data['vat'] = vat;
    data['description'] = description;
    data['createdBy'] = createdBy?.toJson();
    data['createdAt'] = createdAt.toString();
    data['updatedAt'] = updatedAt.toString();
    return data;
  }
}

class CreateCustomerInput {
  final String fullName;
  final String? phone;
  final String? address;
  final int? vat;
  final String? description;

  CreateCustomerInput(
      {required this.fullName,
      this.phone,
      this.address,
      this.vat,
      this.description});
}
