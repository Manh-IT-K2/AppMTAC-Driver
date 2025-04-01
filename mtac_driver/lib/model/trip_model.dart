class TripModel {
  final String txtCode;
  final String txtGlandHead;
  final String txtGlandEnd;
  final String txtType;
  final String txtDay;
  final String txtPrice;

  TripModel({
    required this.txtCode,
    required this.txtGlandHead,
    required this.txtGlandEnd,
    required this.txtType,
    required this.txtDay,
    required this.txtPrice,
  });

  // Convert Map to TripModel
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
        txtCode: map['txtCode'] ?? '',
        txtGlandHead: map['txtGlandHead'] ?? '',
        txtGlandEnd: map['txtGlandEnd'] ?? '',
        txtType: map['txtType'] ?? '',
        txtDay: map['txtDay'] ?? '',
        txtPrice: map['txtPrice'] ?? '');
  }

  // Convert TripModel to Map
  Map<String, dynamic> toMap() {
    return {
      'txtCode': txtCode,
      'txtGlandHead': txtGlandHead,
      'txtGlandEnd': txtGlandEnd,
      'txtType': txtType,
      'txtDay': txtDay,
      'txtPrice': txtPrice
    };
  }
}
