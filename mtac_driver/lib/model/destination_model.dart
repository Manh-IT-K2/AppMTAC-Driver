class DestinationModel {
  final String addressBusiness;
  final String numberBD;
  final String status;
  final String totalWeight;
  final String phonePartner;
  final String note;
  final String namePartner;

  DestinationModel({
    required this.addressBusiness,
    required this.numberBD,
    required this.status,
    required this.totalWeight,
    required this.phonePartner,
    required this.note,
    required this.namePartner,
  });

  // convert Map to DestinationModel
  factory DestinationModel.fromMap(Map<String, dynamic> map) {
    return DestinationModel(
        addressBusiness: map['addressBusiness'] ?? '',
        numberBD: map['numberBD'],
        status: map['status'] ?? '',
        totalWeight: map['totalWeight'] ?? '',
        phonePartner: map['phonePartner'] ?? '',
        namePartner: map['namePartner'],
        note: map['note'] ?? ' ');
  }

  // convert DestinationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'addressBusiness': addressBusiness,
      'numberBD': numberBD,
      'status': status,
      'totalWeight': totalWeight,
      'phonePartner': phonePartner,
      'namePartner': namePartner,
      'note': note,
    };
  }
}
