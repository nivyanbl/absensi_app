class PayslipModel {
  final String id;
  final String userId;
  final int year;
  final int month;
  final String currency;
  final String gross;
  final String net;
  final Map<String, dynamic>? items;
  final DateTime createdAt;
  final DateTime updatedAt;

  PayslipModel({
    required this.id,
    required this.userId,
    required this.year,
    required this.month,
    required this.currency,
    required this.gross,
    required this.net,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) => PayslipModel(
        id: json['id'],
        userId: json['userId'],
        year: json['year'],
        month: json['month'],
        currency: json['currency'],
        gross: json['gross'],
        net: json['net'],
        items: json['items'] == null
            ? null
            : Map<String, dynamic>.from(json['items']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
