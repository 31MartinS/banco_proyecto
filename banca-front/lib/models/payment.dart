class PaymentModel {
  final int id;
  final double amount;
  final String status;
  final String paymentDate;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.paymentDate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'],
      paymentDate: json['payment_date'],
    );
  }
}
