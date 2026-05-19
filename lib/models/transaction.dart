class TransactionModel {
  final String id;
  final String userId;
  final String type;
  final String category;
  final double amount;
  final String description;
  final String paymentMethod;
  final DateTime transactionDate;

  TransactionModel(
      {required this.id,
      required this.userId,
      required this.type,
      required this.category,
      required this.amount,
      required this.description,
      required this.paymentMethod,
      required this.transactionDate});

  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
        id: m['_id'] ?? '',
        userId: m['userId'] ?? '',
        type: m['type'] ?? '',
        category: m['category'] ?? '',
        amount: (m['amount'] ?? 0).toDouble(),
        description: m['description'] ?? '',
        paymentMethod: m['paymentMethod'] ?? '',
        transactionDate: m['transactionDate'] != null
            ? DateTime.parse(m['transactionDate'])
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'userId': userId,
        'type': type,
        'category': category,
        'amount': amount,
        'description': description,
        'paymentMethod': paymentMethod,
        'transactionDate': transactionDate.toIso8601String(),
      };
}
