class AuthorizationCode {
  final String code;
  final String licenseeId;
  final String productId;
  final double amount;
  final int periodMonths;
  final double totalCredit;
  final int productLimit;
  final double discount;

  AuthorizationCode({
    required this.code,
    required this.licenseeId,
    required this.productId,
    required this.amount,
    required this.periodMonths,
    required this.totalCredit,
    required this.productLimit,
    required this.discount,
  });

  // Method to parse JSON into an AuthorizationCode object
  factory AuthorizationCode.fromJson(Map<String, dynamic> json) {
    return AuthorizationCode(
      code: json['code'],
      licenseeId: json['licenseeId'],
      productId: json['productId'],
      amount: (json['amount'] as num).toDouble(),
      periodMonths: json['periodMonths'],
      totalCredit: (json['totalCredit'] as num).toDouble(),
      productLimit: json['productLimit'],
      discount: (json['discount'] as num).toDouble(),
    );
  }

  // Method to convert an AuthorizationCode object to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'licenseeId': licenseeId,
      'productId': productId,
      'amount': amount,
      'periodMonths': periodMonths,
      'totalCredit': totalCredit,
      'productLimit': productLimit,
      'discount': discount,
    };
  }
}
