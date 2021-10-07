class LoginFormData {
  String? email;
  String? password;
  bool? remember;

  LoginFormData({this.email, this.password, this.remember});

  void setEmail(String val) => email = val;
  void setPassword(String val) => password = val;
  void setRemember(bool? val) => remember = val;
}
