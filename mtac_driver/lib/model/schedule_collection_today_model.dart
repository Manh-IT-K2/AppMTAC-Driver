class ScheduleCollectionTodayModel {
  final bool status;
  final String collectionId;
  final String nameBusiness;
  final String addressCollection;
  final String typeWaste;
  final String areaTransit;
  final String numberPlate;
  final String numberWorker;
  final String timeCollection;
  final String dayCollection;
  final String daySendCollection;
  final String contactPerson;
  final String debtStatus;
  final String costTransit;
  final List<String>? image;

  ScheduleCollectionTodayModel({
    required this.status,
    required this.collectionId,
    required this.nameBusiness,
    required this.addressCollection,
    required this.typeWaste,
    required this.areaTransit,
    required this.numberPlate,
    required this.numberWorker,
    required this.timeCollection,
    required this.contactPerson,
    required this.dayCollection,
    required this.daySendCollection,
    required this.debtStatus,
    required this.costTransit,
    this.image,
  });

  // Convert Map to scheduleCollectionTodayModel
  factory ScheduleCollectionTodayModel.fromMap(Map<String, dynamic> map) {
    return ScheduleCollectionTodayModel(
      status: map['status'],
      collectionId: map['collectionId'],
      nameBusiness: map['nameBusiness'],
      addressCollection: map['addressCollection'],
      typeWaste: map['typeWaste'],
      areaTransit: map['areaTransit'],
      numberPlate: map['numberPlate'],
      numberWorker: map['numberWorker'],
      timeCollection: map['timeCollection'],
      contactPerson: map['contactPerson'],
      dayCollection: map[''],
      daySendCollection: map[''],
      debtStatus: map[''],
      costTransit: map[''],
      image: map['image'] != null ? List<String>.from(map['image']) : [],
    );
  }

  // Convert scheduleCollectionTodayModel to Map
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'collectionId': collectionId,
      'nameBusiness': nameBusiness,
      'addressCollection': addressCollection,
      'typeWaste': typeWaste,
      'areaTransit': areaTransit,
      'numberPlate': numberPlate,
      'numberWorker': numberWorker,
      'timeCollection': timeCollection,
      'contactPerson': contactPerson,
      'dayCollection': dayCollection,
      'daySendCollection': daySendCollection,
      'debtStatus': debtStatus,
      'costTransit': costTransit,
      'image': image ?? [],
    };
  }
}
