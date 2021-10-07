enum USER_ROLE { ADMIN, CLIENT, STAFF }

String getUserType(USER_ROLE? type) {
  switch (type) {
    case USER_ROLE.ADMIN:
      return 'Admin';
    case USER_ROLE.CLIENT:
      return 'Client';
    case USER_ROLE.STAFF:
      return 'Staff';
    default:
      return 'Invalid User Type';
  }
}
