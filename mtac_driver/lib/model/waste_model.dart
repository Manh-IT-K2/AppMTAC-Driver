class WasteModel {
  final String name;
  final String code;
  final String status;
  final String number;

  WasteModel({required this.name, required this.code, required this.status, required this.number});

  // Convert Map to WasteModel
  factory WasteModel.fromMap(Map<String, dynamic> map) {
    return WasteModel(
      name: map['sName'] ?? '',
      code: map['sCode'] ?? '',
      status: map['sStatus'] ?? '',
      number: map['sNumber'] ?? '',
    );
  }

  // convert WasteInfo to Map
  Map<String, dynamic> toMap() {
    return {
      'sName': name,
      'sCode': code,
      'sStatus': status,
      'sNumber': number,
    };
  }
}
