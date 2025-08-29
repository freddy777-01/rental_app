class Tenant {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final String propertyName;
  final String? propertyId;
  final String? partitionId;
  final String? partitionName;
  final double rentAmount;
  final int paymentFrequencyMonths; // How many months between payments
  final DateTime moveInDate;
  final DateTime? moveOutDate;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final bool isActive;
  final List<String>? contractPages; // Multiple contract pages
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Tenant({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.propertyName,
    this.propertyId,
    this.partitionId,
    this.partitionName,
    required this.rentAmount,
    this.paymentFrequencyMonths = 1, // Default to monthly payments
    required this.moveInDate,
    this.moveOutDate,
    this.contractStartDate,
    this.contractEndDate,
    this.isActive = true,
    this.contractPages,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'propertyName': propertyName,
      'propertyId': propertyId,
      'partitionId': partitionId,
      'partitionName': partitionName,
      'rentAmount': rentAmount,
      'paymentFrequencyMonths': paymentFrequencyMonths,
      'moveInDate': moveInDate.toIso8601String(),
      'moveOutDate': moveOutDate?.toIso8601String(),
      'contractStartDate': contractStartDate?.toIso8601String(),
      'contractEndDate': contractEndDate?.toIso8601String(),
      'isActive': isActive,
      'contractPages': contractPages,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      propertyName: json['propertyName'] ?? '',
      propertyId: json['propertyId'],
      partitionId: json['partitionId'],
      partitionName: json['partitionName'],
      rentAmount: (json['rentAmount'] ?? 0).toDouble(),
      paymentFrequencyMonths: json['paymentFrequencyMonths'] ?? 1,
      moveInDate:
          json['moveInDate'] != null
              ? DateTime.parse(json['moveInDate'])
              : DateTime.now(),
      moveOutDate:
          json['moveOutDate'] != null
              ? DateTime.parse(json['moveOutDate'])
              : null,
      contractStartDate:
          json['contractStartDate'] != null
              ? DateTime.parse(json['contractStartDate'])
              : null,
      contractEndDate:
          json['contractEndDate'] != null
              ? DateTime.parse(json['contractEndDate'])
              : null,
      isActive: json['isActive'] ?? true,
      contractPages:
          json['contractPages'] != null
              ? List<String>.from(json['contractPages'])
              : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Copy with method
  Tenant copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? propertyName,
    String? propertyId,
    String? partitionId,
    String? partitionName,
    double? rentAmount,
    int? paymentFrequencyMonths,
    DateTime? moveInDate,
    DateTime? moveOutDate,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    bool? isActive,
    List<String>? contractPages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      propertyName: propertyName ?? this.propertyName,
      propertyId: propertyId ?? this.propertyId,
      partitionId: partitionId ?? this.partitionId,
      partitionName: partitionName ?? this.partitionName,
      rentAmount: rentAmount ?? this.rentAmount,
      paymentFrequencyMonths:
          paymentFrequencyMonths ?? this.paymentFrequencyMonths,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      isActive: isActive ?? this.isActive,
      contractPages: contractPages ?? this.contractPages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // To string method
  @override
  String toString() {
    return 'Tenant(id: $id, name: $name, phone: $phone, email: $email, propertyName: $propertyName, propertyId: $propertyId, partitionId: $partitionId, partitionName: $partitionName, rentAmount: $rentAmount, paymentFrequencyMonths: $paymentFrequencyMonths, moveInDate: $moveInDate, moveOutDate: $moveOutDate, contractStartDate: $contractStartDate, contractEndDate: $contractEndDate, isActive: $isActive, contractPages: $contractPages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tenant &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.propertyName == propertyName &&
        other.propertyId == propertyId &&
        other.partitionId == partitionId &&
        other.partitionName == partitionName &&
        other.rentAmount == rentAmount &&
        other.paymentFrequencyMonths == paymentFrequencyMonths &&
        other.moveInDate == moveInDate &&
        other.moveOutDate == moveOutDate &&
        other.contractStartDate == contractStartDate &&
        other.contractEndDate == contractEndDate &&
        other.isActive == isActive &&
        other.contractPages == contractPages &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // Hash code
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        propertyName.hashCode ^
        propertyId.hashCode ^
        partitionId.hashCode ^
        partitionName.hashCode ^
        rentAmount.hashCode ^
        paymentFrequencyMonths.hashCode ^
        moveInDate.hashCode ^
        moveOutDate.hashCode ^
        contractStartDate.hashCode ^
        contractEndDate.hashCode ^
        isActive.hashCode ^
        contractPages.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
