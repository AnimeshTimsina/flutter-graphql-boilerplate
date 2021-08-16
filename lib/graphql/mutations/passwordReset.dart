String gqlPasswordReset(String email) => """
  mutation sendPasswordResetMail {
    sendPasswordResetMail(email:"$email") {
      ok
}
}
""";
