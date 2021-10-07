class CustomerFormData {
  String? fullName;
  String? phone;
  String? address;
  int? vat;
  String? description;

  CustomerFormData(
      {this.fullName, this.phone, this.address, this.vat, this.description});

  void setFullName(String? val) => fullName = val;
  void setPhone(String? val) => phone = val;
  void setDescription(String? val) => description = val;
  void setVat(int? val) => vat = val;
  void setAddress(String? val) => address = val;
}
