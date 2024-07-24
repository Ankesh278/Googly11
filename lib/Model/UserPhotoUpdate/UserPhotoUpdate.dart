class UserPhotoUpdate {
  UserPhotoUpdate({
     required this.status,
    required this.message,
    required this.imageUrl,});

  UserPhotoUpdate.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    imageUrl = json['image_url'] ?? '';
  }
  int status=0;
  String message ='';
  String imageUrl ='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['image_url'] = imageUrl;
    return map;
  }

}