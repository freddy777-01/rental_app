class User {
  final String? id;
  final String name;
  final String phone;
  final String address;
  final String? profileImagePath;
  final String? profileImagePublicId; // Cloudinary public ID
  final String? profileImageUrl; // Full Cloudinary URL
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    this.profileImagePath,
    this.profileImagePublicId,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      profileImagePath: json['profileImagePath'],
      profileImagePublicId: json['profileImagePublicId'],
      profileImageUrl: json['profileImageUrl'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'profileImagePath': profileImagePath,
      'profileImagePublicId': profileImagePublicId,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? profileImagePath,
    String? profileImagePublicId,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      profileImagePublicId: profileImagePublicId ?? this.profileImagePublicId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, address: $address, profileImagePath: $profileImagePath, profileImagePublicId: $profileImagePublicId, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.profileImagePath == profileImagePath &&
        other.profileImagePublicId == profileImagePublicId &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        profileImagePath.hashCode ^
        profileImagePublicId.hashCode ^
        profileImageUrl.hashCode;
  }
}
