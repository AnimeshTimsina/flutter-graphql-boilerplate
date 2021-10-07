const String GQL_CUSTOMERS = """
query allCustomers {
  allCustomers {
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
