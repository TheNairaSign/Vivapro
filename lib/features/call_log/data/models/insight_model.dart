enum InsightType { noContact, weeklyCall }

class InsightModel {
  final String contactName;
  final String contactId;
  final String phoneNumber;
  final int daysSinceLastCall;
  final InsightType type;

  InsightModel({
    required this.contactName,
    required this.contactId,
    required this.phoneNumber,
    required this.daysSinceLastCall,
    required this.type,
  });
}
