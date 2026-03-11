
enum AdStatus {
  available,
  applied,
  approved,
  ongoing,
  completed,
  pendingPayment,
  paid,
  rejected,
}

class AdCampaign {
  final String id;
  final String title;
  final String brandName;
  final String brandLogo;
  final String description;
  final List<String> requirements;
  final String location;
  final double payout;
  final AdStatus status;
  final DateTime? deadline;
  final String? chatGroupId;
  final DateTime? proofSubmittedDate;
  final DateTime? paymentDate;

  const AdCampaign({
    required this.id,
    required this.title,
    required this.brandName,
    required this.brandLogo,
    required this.description,
    required this.requirements,
    required this.location,
    required this.payout,
    this.status = AdStatus.available,
    this.deadline,
    this.chatGroupId,
    this.proofSubmittedDate,
    this.paymentDate,
  });

  AdCampaign copyWith({
    String? id,
    String? title,
    String? brandName,
    String? brandLogo,
    String? description,
    List<String>? requirements,
    String? location,
    double? payout,
    AdStatus? status,
    DateTime? deadline,
    String? chatGroupId,
    DateTime? proofSubmittedDate,
    DateTime? paymentDate,
  }) {
    return AdCampaign(
      id: id ?? this.id,
      title: title ?? this.title,
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      location: location ?? this.location,
      payout: payout ?? this.payout,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      chatGroupId: chatGroupId ?? this.chatGroupId,
      proofSubmittedDate: proofSubmittedDate ?? this.proofSubmittedDate,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}

class InfluencerStats {
  final int totalReach;
  final int activeCampaigns;
  final double totalEarnings;
  final double rating;
  final List<ReachDataPoint> reachHistory;

  const InfluencerStats({
    required this.totalReach,
    required this.activeCampaigns,
    required this.totalEarnings,
    required this.rating,
    required this.reachHistory,
  });
}

class ReachDataPoint {
  final DateTime date;
  final int value;

  const ReachDataPoint(this.date, this.value);
}

enum MessageSender { influencer, brand }

class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final MessageSender sender;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    this.isRead = false,
  });
}
