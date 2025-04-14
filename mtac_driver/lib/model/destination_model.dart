class DestinationModel {
  final int tripId;
  final String nameBusiness;
  final String addressBusiness;
  final String numberBD;
  final String status;
  final String totalWeight;
  final String phonePartner;
  final String note;
  final String namePartner;
  double latitude;
  double longitude;

  DestinationModel({
    required this.tripId,
    required this.nameBusiness,
    required this.addressBusiness,
    required this.numberBD,
    required this.status,
    required this.totalWeight,
    required this.phonePartner,
    required this.note,
    required this.namePartner,
    required this.latitude,
    required this.longitude,
  });

  // convert Map to DestinationModel
  factory DestinationModel.fromMap(Map<String, dynamic> map) {
    return DestinationModel(
      tripId: map['tripId'] ?? '',
        nameBusiness: map['nameBusiness'] ?? '',
        addressBusiness: map['addressBusiness'] ?? '',
        numberBD: map['numberBD'],
        status: map['status'] ?? '',
        totalWeight: map['totalWeight'] ?? '',
        phonePartner: map['phonePartner'] ?? '',
        namePartner: map['namePartner'],
        note: map['note'] ?? ' ',
         latitude: map['latitude'] ?? ' ',
          longitude: map['longitude'] ?? ' ',
        );
  }

  // convert DestinationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'nameBusiness': nameBusiness,
      'addressBusiness': addressBusiness,
      'numberBD': numberBD,
      'status': status,
      'totalWeight': totalWeight,
      'phonePartner': phonePartner,
      'namePartner': namePartner,
      'note': note,
      'latitude': latitude,
      'longitude': longitude,

    };
  }
}
