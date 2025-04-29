import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String accessToken;
    String tokenType;
    User user;
    List<String> roles;

    UserModel({
        required this.accessToken,
        required this.tokenType,
        required this.user,
        required this.roles,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: User.fromJson(json["user"]),
        roles: List<String>.from(json["roles"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "user": user.toJson(),
        "roles": List<dynamic>.from(roles.map((x) => x)),
    };
}

class User {
    int id;
    String name;
    String username;
    String email;
    dynamic masothue;
    String phone;
    String soCccd;
    String adress;
    String soGplx;
    String imgGplxPath;
    String status;
    dynamic emailVerifiedAt;
    dynamic twoFactorConfirmedAt;
    dynamic currentTeamId;
    dynamic profilePhotoPath;
    DateTime createdAt;
    DateTime updatedAt;
    String profilePhotoUrl;
    List<Role> roles;

    User({
        required this.id,
        required this.name,
        required this.username,
        required this.email,
        required this.masothue,
        required this.phone,
        required this.soCccd,
        required this.adress,
        required this.soGplx,
        required this.imgGplxPath,
        required this.status,
        required this.emailVerifiedAt,
        required this.twoFactorConfirmedAt,
        required this.currentTeamId,
        required this.profilePhotoPath,
        required this.createdAt,
        required this.updatedAt,
        required this.profilePhotoUrl,
        required this.roles,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        masothue: json["masothue"],
        phone: json["phone"],
        soCccd: json["soCCCD"],
        adress: json["adress"],
        soGplx: json["soGPLX"],
        imgGplxPath: json["img_GPLX_path"],
        status: json["status"],
        emailVerifiedAt: json["email_verified_at"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        profilePhotoUrl: json["profile_photo_url"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "masothue": masothue,
        "phone": phone,
        "soCCCD": soCccd,
        "adress": adress,
        "soGPLX": soGplx,
        "img_GPLX_path": imgGplxPath,
        "status": status,
        "email_verified_at": emailVerifiedAt,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "profile_photo_url": profilePhotoUrl,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    };
}

class Role {
    int id;
    String name;
    String guardName;
    DateTime createdAt;
    DateTime updatedAt;
    Pivot pivot;

    Role({
        required this.id,
        required this.name,
        required this.guardName,
        required this.createdAt,
        required this.updatedAt,
        required this.pivot,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
    };
}

class Pivot {
    String modelType;
    int modelId;
    int roleId;

    Pivot({
        required this.modelType,
        required this.modelId,
        required this.roleId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelType: json["model_type"],
        modelId: json["model_id"],
        roleId: json["role_id"],
    );

    Map<String, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
    };
}
