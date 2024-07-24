import 'Data.dart';
import 'Links.dart';

class TransactionData {
  TransactionData({
    required  this.currentPage,
    required this.data,
    required  this.firstPageUrl,
    required  this.from,
    required  this.lastPage,
    required  this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required  this.perPage,
    required  this.prevPageUrl,
    required  this.to,
    required  this.total,});

  TransactionData.fromJson(dynamic json) {
    currentPage = json['current_page'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(MainTransactionData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'] ?? '';
    from = json['from'] ?? 0;
    lastPage = json['last_page'] ?? 0;
    lastPageUrl = json['last_page_url']  ?? '';
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'] ?? '';
    path = json['path'] ?? '';
    perPage = json['per_page'] ?? 0;
    prevPageUrl = json['prev_page_url'];
    to = json['to'] ?? 0;
    total = json['total'] ?? 0;
  }
  int currentPage = 0;
  List<MainTransactionData>? data;
  String firstPageUrl = '';
  int from = 0;
  int lastPage = 0;
  String lastPageUrl = '';
  List<Links>? links;
  String nextPageUrl = '';
  String path = '';
  int perPage = 0;
  dynamic prevPageUrl;
  int to = 0;
  int total = 0;

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