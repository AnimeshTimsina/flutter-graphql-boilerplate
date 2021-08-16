String gqlChangePassword(
        String currentPassword, String newPassword, String userId) =>
    """
  mutation passwordChange {
    passwordChange(
      userId: "$userId",
      ChangePassworInput: {
        currentPassword: "$currentPassword",
        newPassword:"$newPassword"
      },
     ) {
       ok
}
}
""";
