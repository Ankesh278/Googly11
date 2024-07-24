import 'Data.dart';
import 'Links.dart';

class AllData {
  AllData({
     required this.currentPage,
    required this.data,
    required  this.firstPageUrl,
    required  this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,});

  AllData.fromJson(dynamic json) {
    currentPage = json['current_page'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(UpcomingMatch_Recents_Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'] = '';
    from = json['from'] = 0;
    lastPage = json['last_page'] = 0;
    lastPageUrl = json['last_page_url'] = '';
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'] ?? '';
    path = json['path'] ?? '';
    perPage = json['per_page'] ?? 0;
    prevPageUrl = json['prev_page_url'] ?? '';
    to = json['to'] ?? 0;
    total = json['total'] ?? 0;
  }
  dynamic currentPage= 0;
  List<UpcomingMatch_Recents_Data>? data;
  dynamic firstPageUrl = '';
  dynamic from = 0;
  dynamic lastPage = 0;
  dynamic lastPageUrl = '';
  List<Links>?  links;
  dynamic nextPageUrl = '';
  dynamic path = '';
  dynamic perPage = 0;
  dynamic prevPageUrl = '';
  dynamic to = 0;
  dynamic total = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    if (links != null) {
      map['links'] = links!.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }

}