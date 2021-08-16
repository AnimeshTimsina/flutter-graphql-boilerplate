class BoolResponse {
  bool? ok;
  BoolResponse({required this.ok});

  BoolResponse.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
  }

  Map toJson() {
    Map data = {};
    data['ok'] = ok;
    return data;
  }
}
