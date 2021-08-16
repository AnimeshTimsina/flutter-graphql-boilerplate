String gqlRevokeRefreshTokens(String? userId) => """
  mutation revokeRefreshTokensForUser {
    revokeRefreshTokensForUser(userId:"$userId") {
      ok
    }
}
""";
