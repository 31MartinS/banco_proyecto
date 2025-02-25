class TransactionModel {
  final int id;
  final String date;
  final double amount;
  final String status;
  final String details;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.details,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      date: json['payment_date'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'],
      details: json['details'],
    );
  }
}
