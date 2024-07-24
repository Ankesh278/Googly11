class SendFeedbackResponse {
  SendFeedbackResponse({
      this.status, 
      this.message,});

  SendFeedbackResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
  }
  int? status;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}