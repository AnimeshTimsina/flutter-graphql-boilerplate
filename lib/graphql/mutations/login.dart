String gqlLogin(String email, String password) => """
  mutation loginFromCredentials {
    login(LoginInput:{
      email:"$email",
      password:"$password"
    }) {
      accessToken
      refreshToken
      user {
        id
        firstName
        lastName
        role
        email
        displayPicture
      }
}
}

""";
