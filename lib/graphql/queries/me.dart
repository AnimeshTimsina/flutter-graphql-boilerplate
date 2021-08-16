const String GQL_USER_INFO = """
query myInfo {
    me {
      id
      firstName
      lastName
      role
      email
      displayPicture
    }
  }
""";
