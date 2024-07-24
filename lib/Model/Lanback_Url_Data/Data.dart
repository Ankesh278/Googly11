import 'Miniscore.dart';
import 'MatchHeader.dart';

class LeanBackData {
  LeanBackData({
     required this.miniscore,
    required this.matchHeader,});

  LeanBackData.fromJson(dynamic json) {
    miniscore = json['miniscore'] != null ? Miniscore.fromJson(json['miniscore']) : null;
    matchHeader = json['matchHeader'] != null ? MatchHeader.fromJson(json['matchHeader']) : null;
  }
  Miniscore? miniscore;
  MatchHeader? matchHeader;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (miniscore != null) {
      map['miniscore'] = miniscore!.toJson();
    }
    if (matchHeader != null) {
      map['matchHeader'] = matchHeader!.toJson();
    }
    return map;
  }

}