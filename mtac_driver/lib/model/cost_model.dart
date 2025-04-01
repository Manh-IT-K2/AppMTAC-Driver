class CostModel {
  final String id;
  final String category;
  final String cost;
  final String quantity;
  final String totalMoney;
  final String note;
  final String status;

  CostModel({
    required this.id,
    required this.category,
    required this.cost,
    required this.quantity,
    required this.totalMoney,
    required this.note,
    required this.status,
  });

  // convert Map to CostModel
  factory CostModel.fromMap(Map<String, dynamic> map) {
    return CostModel(
        id: map['id'] ?? '',
        category: map['category'],
        cost: map['cost'] ?? '',
        quantity: map['quantity'] ?? '',
        totalMoney: map['totalMoney'] ?? '',
        note: map['note'],
        status: map['status'] ?? ' ');
  }

  // convert CostModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'cost': cost,
      'quantity': quantity,
      'totalMoney': totalMoney,
      'note': note,
      'status': status,
    };
  }
}
