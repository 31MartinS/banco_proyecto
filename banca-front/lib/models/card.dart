class CardModel {
  final int id;
  final String cardNumber;
  final String expiryDate;
  final String cardholderName;
  final bool isFrozen;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardholderName,
    required this.isFrozen,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardNumber: json['card_number'],
      expiryDate: json['expiry_date'],
      cardholderName: json['cardholder_name'],
      isFrozen: json['is_frozen'] == 1 || json['is_frozen'] == true,
    );
  }
}
