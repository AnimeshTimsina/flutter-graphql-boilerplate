import 'package:enum_to_string/enum_to_string.dart';
import 'package:omsnepal/graphql/custom_types/custom_user_role.dart';
import 'package:omsnepal/graphql/models/customer.dart';

class User {
  late String id;
  String? firstName;
  String? lastName;
  USER_ROLE? role;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? displayPicture;
  List<Customer>? customersCreated;
  User(
      {required this.id,
      this.firstName,
      this.lastName,
      this.role,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.displayPicture,
      this.customersCreated});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'] != null
        ? EnumToString.fromString(USER_ROLE.values, json['role'])
        : null;
    email = json['email'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    displayPicture = json['displayPicture'];
    customersCreated = json['customersCreated'] != null
        ? List.generate(json['customersCreated'].length,
            (index) => Customer.fromJson(json['customersCreated'][index]))
        : null;
  }

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['role'] = EnumToString.convertToString(role);
    data['email'] = email;
    data['createdAt'] = createdAt?.toString();
    data['updatedAt'] = updatedAt?.toString();
    data['displayPicture'] = displayPicture;
    data['customersCreated'] = List.generate(customersCreated?.length ?? 0,
        (index) => customersCreated![index].toJson());
    return data;
  }
}
