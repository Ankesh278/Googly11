class LeaderboardEntry {
  final int id;
  final String userName;
  final int userMappingId;
  final String winnings;
  final int rank;
  final int totalPlayerPoints;
  final int teamId;
  final String teamName;
  final int userId;
  final bool isCurrentUser;
  final int winningZone;

  LeaderboardEntry({
    required this.id,
    required this.userName,
    required this.userMappingId,
    required this.winnings,
    required this.rank,
    required this.totalPlayerPoints,
    required this.teamId,
    required this.teamName,
    required this.userId,
    required this.isCurrentUser,
    required this.winningZone,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      userMappingId: json['UserMapingId'] ?? 0,
      winnings: json['winnings'] ?? '',
      rank: json['rank'] ?? 0,
      totalPlayerPoints: json['total_player_points'] ?? 0 ,
      teamId: json['teamID'] ?? 0,
      teamName: json['TeamName'] ?? '',
      userId: json['user_id'] ?? 0,
      isCurrentUser: json['isCurrentUser'] ?? false,
      winningZone: json['winningZone'] ?? 0,
    );
  }
}