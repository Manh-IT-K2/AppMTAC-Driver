class MerchandiseModel {
  final String id;
  final String nameGoods;
  final String idGoods;
  final String totalWeight;
  final String warehouse;
  final String processingOwner;

  MerchandiseModel({
    required this.id,
    required this.nameGoods,
    required this.idGoods,
    required this.totalWeight,
    required this.warehouse,
    required this.processingOwner,
  });

  // convert Map to MerchandiseModel
  factory MerchandiseModel.fromMap(Map<String, dynamic> map) {
    return MerchandiseModel(
      id: map['id'] ?? '',
      nameGoods: map['nameGoods'],
      idGoods: map['idGoods'] ?? '',
      totalWeight: map['totalWeight'] ?? '',
      warehouse: map['warehouse'] ?? '',
      processingOwner: map['processingOwner'],
    );
  }

  // convert MerchandiseModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameGoods': nameGoods,
      'idGoods': idGoods,
      'totalWeight': totalWeight,
      'warehouse': warehouse,
      'processingOwner': processingOwner,
    };
  }
}
