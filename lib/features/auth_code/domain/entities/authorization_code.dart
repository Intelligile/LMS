class AuthorizationCode {
  final int id;
  final String code;
  final double amount;
  final int periodMonths;
  final double totalCredit;
  final int productLimit;
  final bool combined;
  final int licenseeId;
  final DateTime createdAt;
  final DateTime periodEndDate;
  final int product;
  final double discount;

  AuthorizationCode({
    required this.id,
    required this.code,
    required this.amount,
    required this.periodMonths,
    required this.totalCredit,
    required this.productLimit,
    required this.combined,
    required this.licenseeId,
    required this.createdAt,
    required this.periodEndDate,
    required this.product,
    required this.discount,
  });

  factory AuthorizationCode.fromJson(Map<String, dynamic> json) {
    return AuthorizationCode(
      id: json['id'],
      code: json['code'],
      amount: json['amount'],
      periodMonths: json['periodMonths'],
      totalCredit: json['totalCredit'],
      productLimit: json['productLimit'],
      combined: json['combined'],
      licenseeId: json['licenseeId'],
      createdAt: DateTime.parse(json['createdAt']),
      periodEndDate: DateTime.parse(json['periodEndDate']),
      product: json['product'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'amount': amount,
      'periodMonths': periodMonths,
      'totalCredit': totalCredit,
      'productLimit': productLimit,
      'combined': combined,
      'licenseeId': licenseeId,
      'createdAt': createdAt.toIso8601String(),
      'periodEndDate': periodEndDate.toIso8601String(),
      'product': product,
      'discount': discount,
    };
  }
}
