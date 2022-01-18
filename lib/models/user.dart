import 'dart:convert';
import 'package:equatable/equatable.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.name,
    this.email,
    this.verified,
    this.emailVerifiedAt,
    this.otp,
    this.profilePicture,
    this.isProfileComplete,
    // this.accountVerified,
    this.accountStatus,
    this.isSocial,
    this.socialType,
    this.socialToken,
    this.deviceType,
    this.deviceToken,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.lat,
    this.long,
    // this.locationRange,
    this.stripeCusId,
    this.deletedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json,
          {String token, bool isVerified = true}) =>
      UserModel(
        id: json['id'],
        name: json['name'],
        verified: isVerified,
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.parse(json['email_verified_at'])
            : null,
        otp: json['otp'],
        profilePicture: json['profile_picture'],
        isProfileComplete: json['is_profile_complete'],
        // accountVerified: json['account_verified'],
        accountStatus: json['account_status'],
        isSocial: json['is_social'],
        socialType: json['social_type'],
        socialToken: json['social_token'],
        deviceType: json['device_type'],
        deviceToken: json['device_token'],
        role: json['role'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        lat: json['lat'],
        long: json['long'],
        // locationRange: json['location_range'],
        stripeCusId: json['stripe_cus_id'],
        deletedAt: json['deleted_at'],
        token: json['token'] ?? token,
      );
  final int id;
  final String email;
  final String name;
  final DateTime emailVerifiedAt;
  final dynamic otp;
  final String profilePicture;
  final int isProfileComplete;
  final String accountStatus;
  final int isSocial;
  final dynamic socialType;
  final dynamic socialToken;
  final String deviceType;
  final String deviceToken;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lat;
  final String long;
  // final int locationRange;
  final String stripeCusId;
  final dynamic deletedAt;
  final String token;
  final bool verified;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at':
            emailVerifiedAt != null ? emailVerifiedAt.toIso8601String() : null,
        'otp': otp,
        'profile_picture': profilePicture,
        'is_profile_complete': isProfileComplete,
        // 'account_verified': accountVerified,
        'account_status': accountStatus,
        'is_social': isSocial,
        'social_type': socialType,
        'social_token': socialToken,
        'device_type': deviceType,
        'device_token': deviceToken,
        'role': role,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'lat': lat,
        'long': long,
        // 'location_range': locationRange,
        'stripe_cus_id': stripeCusId,
        'deleted_at': deletedAt,
        'token': token,
      };
  @override
  List<Object> get props =>
      [id, name, email, otp, profilePicture, socialToken, deviceToken];
}
