class EnquiryApiModel {
  EnquiryApiModel({
     required this.clientCode,
     required this.statusResponseData,});

  EnquiryApiModel.fromJson(dynamic json) {
    clientCode = json['clientCode'];
    statusResponseData = json['statusResponseData'];
  }
  String clientCode="";
  String statusResponseData="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clientCode'] = clientCode;
    map['statusResponseData'] = statusResponseData;
    return map;
  }

}