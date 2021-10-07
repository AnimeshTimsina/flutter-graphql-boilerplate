import 'package:omsnepal/graphql/models/customer.dart';

String gqlCreateCustomer(CreateCustomerInput input) {
  bool _isEmpty(dynamic e) {
    if (e == null || e == "") return true;
    return false;
  }

  final _phoneNumber = _isEmpty(input.phone) ? "" : 'phone : "${input.phone}",';
  final _vat = _isEmpty(input.vat) ? "" : 'vat : ${input.vat},';
  final _address =
      _isEmpty(input.address) ? "" : 'address : "${input.address}",';
  final _description = _isEmpty(input.description)
      ? ""
      : 'description : "${input.description}",';
  final _fullName = 'fullName : "${input.fullName}"';

  return """
  mutation CreateCustomerMutation {
    createCustomer(     
        CustomerInput: {
          $_phoneNumber
          $_vat
          $_address
          $_description
          $_fullName
        },
      ) 
      {  
           id
    fullName
    phone
    address
    vat
    description
    createdAt
    updatedAt
    createdBy {
      id
      firstName
      lastName
      role
      email
      createdAt
      updatedAt
      displayPicture
    }
      }
  }
""";
}
