class DeleteResponse {
  String? id;
  bool? success;
  DeleteResponse({required this.id, required this.success});

  DeleteResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    success = json['success'];
  }

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['success'] = success;
    return data;
  }
}
