import 'package:enum_to_string/enum_to_string.dart';
import 'package:omsnepal/graphql/custom_types/custom_user_role.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  USER_ROLE? role;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? displayPicture;
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.role,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.displayPicture});

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
    return data;
  }
}
