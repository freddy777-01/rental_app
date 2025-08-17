import 'package:flutter/material.dart';

enum RoomType {
  singleRoom, // Single room without toilet
  selfContained, // Room with toilet inside
  twoRooms, // Two rooms without toilet (shared toilet outside)
}

class Room {
  final String id;
  final String name;
  final RoomType type;
  final double monthlyRent;
  final bool isOccupied;
  final String? currentTenantId;
  final String? currentTenantName;
  final DateTime? occupiedSince;
  final List<String> amenities; // e.g., ["Furnished", "Balcony", "Kitchen"]

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.monthlyRent,
    this.isOccupied = false,
    this.currentTenantId,
    this.currentTenantName,
    this.occupiedSince,
    this.amenities = const [],
  });

  String get typeDescription {
    switch (type) {
      case RoomType.singleRoom:
        return 'Single Room';
      case RoomType.selfContained:
        return 'Self Contained';
      case RoomType.twoRooms:
        return 'Two Rooms';
    }
  }

  String get toiletStatus {
    switch (type) {
      case RoomType.singleRoom:
        return 'Shared Toilet';
      case RoomType.selfContained:
        return 'Private Toilet';
      case RoomType.twoRooms:
        return 'Shared Toilet';
    }
  }

  Room copyWith({
    String? id,
    String? name,
    RoomType? type,
    double? monthlyRent,
    bool? isOccupied,
    String? currentTenantId,
    String? currentTenantName,
    DateTime? occupiedSince,
    List<String>? amenities,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      isOccupied: isOccupied ?? this.isOccupied,
      currentTenantId: currentTenantId ?? this.currentTenantId,
      currentTenantName: currentTenantName ?? this.currentTenantName,
      occupiedSince: occupiedSince ?? this.occupiedSince,
      amenities: amenities ?? this.amenities,
    );
  }
}

class Property {
  final String id;
  final String name;
  final String location;
  final String address;
  final String description;
  final List<Room> rooms;
  final DateTime purchaseDate;
  final double purchasePrice;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final bool isActive;
  final List<String> images; // Property images
  final Map<String, dynamic> additionalInfo; // For any extra details

  Property({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.description,
    required this.rooms,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    this.isActive = true,
    this.images = const [],
    this.additionalInfo = const {},
  });

  // Computed properties
  int get totalRooms => rooms.length;
  int get occupiedRooms => rooms.where((room) => room.isOccupied).length;
  int get availableRooms => totalRooms - occupiedRooms;
  double get totalMonthlyRent =>
      rooms.fold(0, (sum, room) => sum + room.monthlyRent);
  double get occupiedMonthlyRent => rooms
      .where((room) => room.isOccupied)
      .fold(0, (sum, room) => sum + room.monthlyRent);
  double get occupancyRate =>
      totalRooms > 0 ? (occupiedRooms / totalRooms) * 100 : 0;

  // Room statistics by type
  int get singleRooms =>
      rooms.where((room) => room.type == RoomType.singleRoom).length;
  int get selfContainedRooms =>
      rooms.where((room) => room.type == RoomType.selfContained).length;
  int get twoRoomsUnits =>
      rooms.where((room) => room.type == RoomType.twoRooms).length;

  // Available rooms by type
  int get availableSingleRooms =>
      rooms
          .where((room) => room.type == RoomType.singleRoom && !room.isOccupied)
          .length;
  int get availableSelfContained =>
      rooms
          .where(
            (room) => room.type == RoomType.selfContained && !room.isOccupied,
          )
          .length;
  int get availableTwoRooms =>
      rooms
          .where((room) => room.type == RoomType.twoRooms && !room.isOccupied)
          .length;

  Property copyWith({
    String? id,
    String? name,
    String? location,
    String? address,
    String? description,
    List<Room>? rooms,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    bool? isActive,
    List<String>? images,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      address: address ?? this.address,
      description: description ?? this.description,
      rooms: rooms ?? this.rooms,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      isActive: isActive ?? this.isActive,
      images: images ?? this.images,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
