enum PartitionType {
  selfContained, // With private toilet
  notSelfContained, // Shared toilet outside
}

class Partition {
  final String id;
  final String name; // Partition/segment name
  final PartitionType type;
  final double monthlyRent;
  final bool isOccupied;
  final String? currentTenantId;
  final String? currentTenantName;
  final DateTime? occupiedSince;

  // Partition properties
  final bool hasLivingRoom;
  final int numberOfRooms;
  final List<String> amenities; // Room amenities

  Partition({
    required this.id,
    required this.name,
    required this.type,
    required this.monthlyRent,
    this.isOccupied = false,
    this.currentTenantId,
    this.currentTenantName,
    this.occupiedSince,
    this.hasLivingRoom = false,
    this.numberOfRooms = 1,
    this.amenities = const [],
  });

  String get typeDescription {
    switch (type) {
      case PartitionType.selfContained:
        return 'Self Contained';
      case PartitionType.notSelfContained:
        return 'Not Self Contained';
    }
  }

  String get toiletStatus {
    switch (type) {
      case PartitionType.selfContained:
        return 'Private Toilet';
      case PartitionType.notSelfContained:
        return 'Shared Toilet';
    }
  }

  Partition copyWith({
    String? id,
    String? name,
    PartitionType? type,
    double? monthlyRent,
    bool? isOccupied,
    String? currentTenantId,
    String? currentTenantName,
    DateTime? occupiedSince,
    bool? hasLivingRoom,
    int? numberOfRooms,
    List<String>? amenities,
  }) {
    return Partition(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      isOccupied: isOccupied ?? this.isOccupied,
      currentTenantId: currentTenantId ?? this.currentTenantId,
      currentTenantName: currentTenantName ?? this.currentTenantName,
      occupiedSince: occupiedSince ?? this.occupiedSince,
      hasLivingRoom: hasLivingRoom ?? this.hasLivingRoom,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      amenities: amenities ?? this.amenities,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'monthlyRent': monthlyRent,
      'isOccupied': isOccupied,
      'currentTenantId': currentTenantId,
      'currentTenantName': currentTenantName,
      'occupiedSince': occupiedSince?.toIso8601String(),
      'hasLivingRoom': hasLivingRoom,
      'numberOfRooms': numberOfRooms,
      'amenities': amenities,
    };
  }

  // Create from JSON
  factory Partition.fromJson(Map<String, dynamic> json) {
    return Partition(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: PartitionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PartitionType.notSelfContained,
      ),
      monthlyRent: (json['monthlyRent'] ?? 0).toDouble(),
      isOccupied: json['isOccupied'] ?? false,
      currentTenantId: json['currentTenantId'],
      currentTenantName: json['currentTenantName'],
      occupiedSince:
          json['occupiedSince'] != null
              ? DateTime.parse(json['occupiedSince'])
              : null,
      hasLivingRoom: json['hasLivingRoom'] ?? false,
      numberOfRooms: json['numberOfRooms'] ?? 1,
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }
}

class Property {
  final String? id;
  final String name; // Block name
  final String? address; // Optional
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail; // Optional
  final List<Partition> partitions; // Segments/partitions
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? purchaseDate; // Optional
  final double? purchasePrice; // Optional

  Property({
    this.id,
    required this.name,
    this.address,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerEmail,
    this.partitions = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.purchaseDate,
    this.purchasePrice,
  });

  // Computed properties
  int get totalPartitions => partitions.length;
  int get occupiedPartitions =>
      partitions.where((partition) => partition.isOccupied).length;
  int get availablePartitions => totalPartitions - occupiedPartitions;
  double get totalMonthlyRent =>
      partitions.fold(0, (sum, partition) => sum + partition.monthlyRent);
  double get occupiedMonthlyRent => partitions
      .where((partition) => partition.isOccupied)
      .fold(0, (sum, partition) => sum + partition.monthlyRent);
  double get occupancyRate =>
      totalPartitions > 0 ? (occupiedPartitions / totalPartitions) * 100 : 0;

  // Partition statistics by type
  int get selfContainedPartitions =>
      partitions
          .where((partition) => partition.type == PartitionType.selfContained)
          .length;
  int get notSelfContainedPartitions =>
      partitions
          .where(
            (partition) => partition.type == PartitionType.notSelfContained,
          )
          .length;

  // Available partitions by type
  int get availableSelfContained =>
      partitions
          .where(
            (partition) =>
                partition.type == PartitionType.selfContained &&
                !partition.isOccupied,
          )
          .length;
  int get availableNotSelfContained =>
      partitions
          .where(
            (partition) =>
                partition.type == PartitionType.notSelfContained &&
                !partition.isOccupied,
          )
          .length;

  // Get available partitions
  List<Partition> get availablePartitionsList =>
      partitions.where((partition) => !partition.isOccupied).toList();

  // Get occupied partitions
  List<Partition> get occupiedPartitionsList =>
      partitions.where((partition) => partition.isOccupied).toList();

  // Assign tenant to partition
  Property assignTenantToPartition(
    String partitionId,
    String tenantId,
    String tenantName,
  ) {
    final updatedPartitions =
        partitions.map((partition) {
          if (partition.id == partitionId) {
            return partition.copyWith(
              isOccupied: true,
              currentTenantId: tenantId,
              currentTenantName: tenantName,
              occupiedSince: DateTime.now(),
            );
          }
          return partition;
        }).toList();

    return copyWith(partitions: updatedPartitions, updatedAt: DateTime.now());
  }

  // Unassign tenant from partition
  Property unassignTenantFromPartition(String partitionId) {
    final updatedPartitions =
        partitions.map((partition) {
          if (partition.id == partitionId) {
            return partition.copyWith(
              isOccupied: false,
              currentTenantId: null,
              currentTenantName: null,
              occupiedSince: null,
            );
          }
          return partition;
        }).toList();

    return copyWith(partitions: updatedPartitions, updatedAt: DateTime.now());
  }

  // Get partition by ID
  Partition? getPartitionById(String partitionId) {
    try {
      return partitions.firstWhere((partition) => partition.id == partitionId);
    } catch (e) {
      return null;
    }
  }

  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    List<Partition>? partitions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? purchaseDate,
    double? purchasePrice,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      partitions: partitions ?? this.partitions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'partitions': partitions.map((p) => p.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'purchaseDate': purchaseDate?.toIso8601String(),
      'purchasePrice': purchasePrice,
    };
  }

  // Create from JSON
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'],
      ownerName: json['ownerName'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      ownerEmail: json['ownerEmail'],
      partitions:
          (json['partitions'] as List<dynamic>?)
              ?.map((p) => Partition.fromJson(p))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      purchaseDate:
          json['purchaseDate'] != null
              ? DateTime.parse(json['purchaseDate'])
              : null,
      purchasePrice: json['purchasePrice']?.toDouble(),
    );
  }
}
