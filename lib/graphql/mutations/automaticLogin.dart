String gqlAutomaticLogin(String refreshToken) => """
  mutation getNewToken {
    getNewToken(getNewTokenInput:{refreshToken: "$refreshToken"}) {
          user {
            id
            firstName
            lastName
            role
            email
            displayPicture
          }
          accessToken
          refreshToken 
}
}
""";
