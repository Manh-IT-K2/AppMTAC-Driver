// class ScheduleModel {
//   final int id;
//   final String title;
//   final String nameWaste;
//   final String addressBusiness;
//   final String day;
//   final String status;

//   ScheduleModel({
//     required this.id,
//     required this.title,
//     required this.nameWaste,
//     required this.addressBusiness,
//     required this.day,
//     required this.status,
//   });

//   // convert Map to ScheduleModel
//   factory ScheduleModel.fromMap(Map<String, dynamic> map) {
//     return ScheduleModel(
//         id: map['id'] ?? '',
//         title: map['title'] ?? '',
//         nameWaste: map['nameWaste'] ?? '',
//         addressBusiness: map['addressBusiness'] ?? '',
//         day: map['day'] ?? '',
//         status: map['status'] ?? ' ');
//   }

//   // convert ScheduleModel to Map
//   Map<String,dynamic> toMap(){
//     return {
//       'id' : id,
//       'title' : title,
//       'nameWaste' : nameWaste,
//       'addressBusiness' : addressBusiness,
//       'day' : day,
//       'status' : status,
//     };
//   }
// }
// To parse this JSON data, do
//
//     final ScheduleModel = ScheduleModelFromJson(jsonString);

import 'dart:convert';

ScheduleModel scheduleModelFromJson(String str) =>
    ScheduleModel.fromJson(json.decode(str));

String scheduleModelToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  bool success;
  List<Datum> data;

  ScheduleModel({
    required this.success,
    required this.data,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String code;
  String companyName;
  String locationDetails;
  String wasteType;
  DateTime collectionDate;
  String area;
  Truck truck;
  String status;
  List<Good> goods;
  List<String> images;
  double? latitude;
  double? longitude;

  Datum({
    required this.id,
    required this.code,
    required this.companyName,
    required this.locationDetails,
    required this.wasteType,
    required this.collectionDate,
    required this.area,
    required this.truck,
    required this.status,
    required this.goods,
    required this.images,
    this.latitude,
    this.longitude,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        code: json["code"],
        companyName: json["company_name"],
        locationDetails: json["location_details"],
        wasteType: json["waste_type"],
        collectionDate: DateTime.parse(json["collection_date"]),
        area: json["area"],
        truck: Truck.fromJson(json["truck"]),
        status: json["status"],
        goods: List<Good>.from(json["goods"].map((x) => Good.fromJson(x))),
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : [],
        latitude: 0.0,
        longitude: 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "company_name": companyName,
        "location_details": locationDetails,
        "waste_type": wasteType,
        "collection_date":
            "${collectionDate.year.toString().padLeft(4, '0')}-${collectionDate.month.toString().padLeft(2, '0')}-${collectionDate.day.toString().padLeft(2, '0')}",
        "area": area,
        "truck": truck.toJson(),
        "status": status,
        "goods": List<dynamic>.from(goods.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x)),
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Good {
  String name;
  String quantity;

  Good({
    required this.name,
    required this.quantity,
  });

  factory Good.fromJson(Map<String, dynamic> json) => Good(
        name: json["name"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
      };
}

class Truck {
  String plateNumber;
  String name;

  Truck({
    required this.plateNumber,
    required this.name,
  });

  factory Truck.fromJson(Map<String, dynamic> json) => Truck(
        plateNumber: json["plate_number"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "plate_number": plateNumber,
        "name": name,
      };
}
