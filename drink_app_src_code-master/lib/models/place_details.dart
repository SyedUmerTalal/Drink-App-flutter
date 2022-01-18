import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

DPlaceDetailResponse dPlaceDetailResponseFromJson(String str) {
  try {
    return DPlaceDetailResponse.fromJson(jsonDecode(str));
  } catch (e) {
    throw PlatformException(code: '0', message: e.toString());
  }
}

String dPlaceDetailResponseToJson(DPlaceDetailResponse dPlaceDetailResponse) =>
    json.encode(dPlaceDetailResponse.toJson());

// To parse this JSON DPlaceDetails, do
//
//     final DPlaceDetailResponse = topLevelFromJson(jsonString);

DPlaceDetailResponse topLevelFromJson(String str) =>
    DPlaceDetailResponse.fromJson(json.decode(str));

String topLevelToJson(DPlaceDetailResponse dPlaceDetails) =>
    json.encode(dPlaceDetails.toJson());

class DPlaceDetailResponse {
  DPlaceDetailResponse({
    this.status,
    this.message,
    this.dPlaceDetails,
  });
  factory DPlaceDetailResponse.fromJson(Map<String, dynamic> json) =>
      DPlaceDetailResponse(
        status: json['status'],
        message: json['message'],
        dPlaceDetails: DPlaceDetails.fromJson(json['DPlaceDetails']),
      );
  int status;
  String message;
  DPlaceDetails dPlaceDetails;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'DPlaceDetails': dPlaceDetails.toJson(),
      };
}

class DPlaceDetails extends Equatable {
  const DPlaceDetails({
    this.id,
    this.name,
    this.address,
    this.distance,
    this.lat,
    this.long,
    this.images,
    this.categories,
  });

  factory DPlaceDetails.fromJson(Map<String, dynamic> json) => DPlaceDetails(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        distance: json['distance'],
        lat: json['lat'],
        long: json['long'],
        images: List<PlaceImage>.from(
            json['images'].map((x) => PlaceImage.fromJson(x))),
        categories: Categories.fromJson(json['categories']),
      );

  final int id;
  final String name;
  final String address;
  final String distance;
  final String lat;
  final String long;
  final List<PlaceImage> images;
  final Categories categories;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'distance': distance,
        'lat': lat,
        'long': long,
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
        'categories': categories.toJson(),
      };

  @override
  List<Object> get props =>
      [id, name, address, distance, lat, long, images, categories];
}

class Categories extends Equatable {
  const Categories({
    this.drinks,
    this.bites,
  });
  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        drinks: List<Bite>.from(json['drinks'].map((x) => Bite.fromJson(x))),
        bites: List<Bite>.from(json['bites'].map((x) => Bite.fromJson(x))),
      );
  final List<Bite> drinks;
  final List<Bite> bites;

  Map<String, dynamic> toJson() => {
        'drinks': List<dynamic>.from(drinks.map((x) => x.toJson())),
        'bites': List<dynamic>.from(bites.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [bites, drinks];
}

class Bite extends Equatable {
  const Bite({
    this.id,
    this.title,
    this.type,
  });
  factory Bite.fromJson(Map<String, dynamic> json) => Bite(
        id: json['id'],
        title: json['title'],
        type: json['type'],
      );
  final int id;
  final String title;
  final String type;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
      };

  @override
  List<Object> get props => [id, title, type];
}

class PlaceImage {
  PlaceImage({
    this.url,
  });
  factory PlaceImage.fromJson(Map<String, dynamic> json) => PlaceImage(
        url: json['url'],
      );
  String url;

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
