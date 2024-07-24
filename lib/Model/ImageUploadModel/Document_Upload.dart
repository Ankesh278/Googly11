class DocumentUpload {
  DocumentUpload({
     required this.status,
    required  this.message,
    required  this.frontImageUrl,
    required  this.backImageUrl,});

  DocumentUpload.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    frontImageUrl = json['front_image_url'] ?? '';
    backImageUrl = json['back_image_url'] ?? '';
  }
  int status = 0;
  String message = "";
  String frontImageUrl = "";
  String backImageUrl = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['front_image_url'] = frontImageUrl;
    map['back_image_url'] = backImageUrl;
    return map;
  }

}