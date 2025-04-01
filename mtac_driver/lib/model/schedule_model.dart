class ScheduleModel {
  final String title;
  final String nameWaste;
  final String addressBusiness;
  final String day;
  final String status;

  ScheduleModel({
    required this.title,
    required this.nameWaste,
    required this.addressBusiness,
    required this.day,
    required this.status,
  });

  // convert Map to ScheduleModel
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
        title: map['title'] ?? '',
        nameWaste: map['nameWaste'] ?? '',
        addressBusiness: map['addressBusiness'] ?? '',
        day: map['day'] ?? '',
        status: map['status'] ?? ' ');
  }

  // convert ScheduleModel to Map
  Map<String,dynamic> toMap(){
    return {
      'title' : title,
      'nameWaste' : nameWaste,
      'addressBusiness' : addressBusiness,
      'day' : day,
      'status' : status,
    };
  }
}
