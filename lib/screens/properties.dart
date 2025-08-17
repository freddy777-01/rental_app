import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import '../models/property.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSampleProperties();
    _filteredProperties = _allProperties;
  }

  void _loadSampleProperties() {
    _allProperties.addAll([
      Property(
        id: '1',
        name: 'Sunset Apartments',
        location: 'Mikocheni',
        address: 'Plot 123, Mikocheni B, Dar es Salaam',
        description: 'Modern apartment complex with various room types',
        rooms: [
          Room(
            id: '1',
            name: 'Room 1A',
            type: RoomType.selfContained,
            monthlyRent: 180000,
            isOccupied: true,
            currentTenantName: 'Reginald Raymond',
            occupiedSince: DateTime(2024, 1, 15),
            amenities: ['Furnished', 'Balcony', 'Kitchen'],
          ),
          Room(
            id: '2',
            name: 'Room 1B',
            type: RoomType.singleRoom,
            monthlyRent: 120000,
            isOccupied: false,
            amenities: ['Furnished'],
          ),
          Room(
            id: '3',
            name: 'Room 2A',
            type: RoomType.twoRooms,
            monthlyRent: 250000,
            isOccupied: true,
            currentTenantName: 'Heyday Dismiss',
            occupiedSince: DateTime(2024, 2, 1),
            amenities: ['Furnished', 'Kitchen'],
          ),
        ],
        purchaseDate: DateTime(2020, 6, 15),
        purchasePrice: 45000000,
        ownerName: 'John Doe',
        ownerPhone: '+255 700 123 456',
        ownerEmail: 'john.doe@email.com',
      ),
      Property(
        id: '2',
        name: 'Green Valley House',
        location: 'Masaki',
        address: 'House 45, Green Valley Street, Masaki',
        description: 'Spacious family house converted to rental units',
        rooms: [
          Room(
            id: '4',
            name: 'Main Unit',
            type: RoomType.selfContained,
            monthlyRent: 300000,
            isOccupied: true,
            currentTenantName: 'Henna Sinbad',
            occupiedSince: DateTime(2024, 3, 10),
            amenities: ['Furnished', 'Garden', 'Parking'],
          ),
          Room(
            id: '5',
            name: 'Studio Unit',
            type: RoomType.singleRoom,
            monthlyRent: 150000,
            isOccupied: false,
            amenities: ['Furnished'],
          ),
        ],
        purchaseDate: DateTime(2018, 12, 10),
        purchasePrice: 35000000,
        ownerName: 'John Doe',
        ownerPhone: '+255 700 123 456',
        ownerEmail: 'john.doe@email.com',
      ),
    ]);
  }

  void _filterProperties(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProperties = _allProperties;
        _isSearching = false;
      } else {
        _filteredProperties =
            _allProperties
                .where(
                  (property) =>
                      property.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      property.location.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      property.address.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
        _isSearching = true;
      }
    });
  }

  void _addProperty() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddPropertyForm(),
    ).then((newProperty) {
      if (newProperty != null) {
        setState(() {
          _allProperties.add(newProperty);
          _filteredProperties = _allProperties;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newProperty.name} added successfully!')),
        );
      }
    });
  }

  void _deleteProperty(Property property) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Property'),
            content: Text('Are you sure you want to delete ${property.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _allProperties.remove(property);
                    _filteredProperties = _allProperties;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${property.name} deleted successfully!'),
                    ),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _viewPropertyDetails(Property property) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF3F51B5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Property Details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basic Info
                          _buildInfoSection('Basic Information', [
                            _buildInfoRow('Location', property.location),
                            _buildInfoRow('Address', property.address),
                            _buildInfoRow('Description', property.description),
                            _buildInfoRow('Owner', property.ownerName),
                            _buildInfoRow('Owner Phone', property.ownerPhone),
                            _buildInfoRow('Owner Email', property.ownerEmail),
                            _buildInfoRow(
                              'Purchase Date',
                              '${property.purchaseDate.day}/${property.purchaseDate.month}/${property.purchaseDate.year}',
                            ),
                            _buildInfoRow(
                              'Purchase Price',
                              'TZS ${property.purchasePrice.toStringAsFixed(0)}',
                            ),
                          ]),

                          Gap(16),

                          // Statistics
                          _buildInfoSection('Property Statistics', [
                            _buildInfoRow(
                              'Total Rooms',
                              '${property.totalRooms}',
                            ),
                            _buildInfoRow(
                              'Occupied Rooms',
                              '${property.occupiedRooms}',
                            ),
                            _buildInfoRow(
                              'Available Rooms',
                              '${property.availableRooms}',
                            ),
                            _buildInfoRow(
                              'Occupancy Rate',
                              '${property.occupancyRate.toStringAsFixed(1)}%',
                            ),
                            _buildInfoRow(
                              'Total Monthly Rent',
                              'TZS ${property.totalMonthlyRent.toStringAsFixed(0)}',
                            ),
                            _buildInfoRow(
                              'Occupied Monthly Rent',
                              'TZS ${property.occupiedMonthlyRent.toStringAsFixed(0)}',
                            ),
                          ]),

                          Gap(16),

                          // Room Types
                          _buildInfoSection('Room Types', [
                            _buildInfoRow(
                              'Single Rooms',
                              '${property.singleRooms} (${property.availableSingleRooms} available)',
                            ),
                            _buildInfoRow(
                              'Self Contained',
                              '${property.selfContainedRooms} (${property.availableSelfContained} available)',
                            ),
                            _buildInfoRow(
                              'Two Rooms Units',
                              '${property.twoRoomsUnits} (${property.availableTwoRooms} available)',
                            ),
                          ]),

                          Gap(16),

                          // Rooms List
                          _buildInfoSection('All Rooms', [
                            ...property.rooms.map(
                              (room) => _buildRoomInfo(room),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3F51B5).withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Gap(12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Color(0xFF2C3E50))),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfo(Room room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: room.isOccupied ? Color(0xFF2ECC71) : Color(0xFFE74C3C),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                room.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      room.isOccupied ? Color(0xFF2ECC71) : Color(0xFFE74C3C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  room.isOccupied ? 'Occupied' : 'Available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Gap(4),
          Text(
            '${room.typeDescription} - ${room.toiletStatus}',
            style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 12),
          ),
          Gap(4),
          Text(
            'TZS ${room.monthlyRent.toStringAsFixed(0)}',
            style: TextStyle(
              color: Color(0xFF2ECC71),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (room.isOccupied) ...[
            Gap(4),
            Text(
              'Tenant: ${room.currentTenantName}',
              style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 12),
            ),
          ],
          if (room.amenities.isNotEmpty) ...[
            Gap(4),
            Wrap(
              spacing: 4,
              children:
                  room.amenities
                      .map(
                        (amenity) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF3F51B5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              color: Color(0xFF3F51B5),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        backgroundColor: Color(0xFF3F51B5), // Primary: Indigo Blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F6FA), // Background: Light Gray
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProperties,
                decoration: InputDecoration(
                  hintText: 'Search properties by name, location...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _isSearching
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterProperties('');
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Color(0xFF3F51B5),
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF), // Surface: White
                ),
              ),
            ),

            // Properties List
            Expanded(
              child:
                  _filteredProperties.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSearching
                                  ? Icons.search_off
                                  : Icons.home_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            Gap(16),
                            Text(
                              _isSearching
                                  ? 'No properties found matching your search'
                                  : 'No properties added yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!_isSearching) ...[
                              Gap(16),
                              ElevatedButton.icon(
                                onPressed: _addProperty,
                                icon: const Icon(Icons.add),
                                label: const Text('Add First Property'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFF2ECC71,
                                  ), // Accent: Emerald Green
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredProperties.length,
                        itemBuilder: (context, index) {
                          final property = _filteredProperties[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF), // Surface: White
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(
                                  0xFF3F51B5,
                                ), // Primary: Indigo Blue
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(
                                  0xFF3F51B5,
                                ), // Primary: Indigo Blue
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                property.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2C3E50), // Text: Primary
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Color(
                                          0xFF7F8C8D,
                                        ), // Text: Secondary
                                      ),
                                      Gap(4),
                                      Text(
                                        property.location,
                                        style: TextStyle(
                                          color: Color(0xFF7F8C8D),
                                        ), // Text: Secondary
                                      ),
                                    ],
                                  ),
                                  Gap(2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.room,
                                        size: 16,
                                        color: Color(
                                          0xFF7F8C8D,
                                        ), // Text: Secondary
                                      ),
                                      Gap(4),
                                      Text(
                                        '${property.occupiedRooms}/${property.totalRooms} rooms occupied',
                                        style: TextStyle(
                                          color: Color(0xFF7F8C8D),
                                        ), // Text: Secondary
                                      ),
                                    ],
                                  ),
                                  Gap(2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        size: 16,
                                        color: Color(
                                          0xFF7F8C8D,
                                        ), // Text: Secondary
                                      ),
                                      Gap(4),
                                      Text(
                                        'TZS ${property.totalMonthlyRent.toStringAsFixed(0)}/month',
                                        style: TextStyle(
                                          color: Color(0xFF7F8C8D),
                                        ), // Text: Secondary
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed:
                                        () => _viewPropertyDetails(property),
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Color(0xFF3F51B5),
                                    ),
                                    tooltip: 'View Details',
                                  ),
                                  PopupMenuButton(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                Gap(8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                Gap(8),
                                                Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        // TODO: Implement edit functionality
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Edit functionality coming soon!',
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _deleteProperty(property);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProperty,
        backgroundColor: Color(0xFF2ECC71), // Accent: Emerald Green
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
    );
  }
}

class AddPropertyForm extends StatefulWidget {
  const AddPropertyForm({super.key});

  @override
  State<AddPropertyForm> createState() => _AddPropertyFormState();
}

class _AddPropertyFormState extends State<AddPropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _purchasePriceController = TextEditingController();

  DateTime _purchaseDate = DateTime.now();
  final List<Room> _rooms = [];

  // Room form controllers
  final _roomNameController = TextEditingController();
  final _roomRentController = TextEditingController();
  RoomType _selectedRoomType = RoomType.singleRoom;
  final List<String> _selectedAmenities = [];

  final List<String> _availableAmenities = [
    'Furnished',
    'Kitchen',
    'Balcony',
    'Garden',
    'Parking',
    'Security',
    'Water',
    'Electricity',
    'Internet',
    'Air Conditioning',
  ];

  void _addRoom() {
    if (_roomNameController.text.trim().isEmpty ||
        _roomRentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in room name and rent')),
      );
      return;
    }

    final room = Room(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _roomNameController.text.trim(),
      type: _selectedRoomType,
      monthlyRent: double.parse(_roomRentController.text),
      amenities: List.from(_selectedAmenities),
    );

    setState(() {
      _rooms.add(room);
      _roomNameController.clear();
      _roomRentController.clear();
      _selectedAmenities.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${room.name} added successfully!')));
  }

  void _removeRoom(int index) {
    setState(() {
      _rooms.removeAt(index);
    });
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_selectedAmenities.contains(amenity)) {
        _selectedAmenities.remove(amenity);
      } else {
        _selectedAmenities.add(amenity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF3F51B5), // Primary: Indigo Blue
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Property',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Basic Information
                    Text(
                      'Property Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Property Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter property name';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Full Address *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    Gap(16),

                    // Purchase Information
                    Text(
                      'Purchase Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Gap(16),

                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _purchaseDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Purchase Date *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_purchaseDate.day}/${_purchaseDate.month}/${_purchaseDate.year}',
                        ),
                      ),
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _purchasePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price (TZS) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter purchase price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    // Owner Information
                    Text(
                      'Owner Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _ownerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Owner Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner name';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _ownerPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Owner Phone *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner phone';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    TextFormField(
                      controller: _ownerEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Owner Email *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    Gap(24),

                    // Rooms Section
                    Text(
                      'Rooms (${_rooms.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Gap(16),

                    // Add Room Form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF3F51B5).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Room',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Gap(12),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _roomNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Room Name',
                                    border: OutlineInputBorder(),
                                    hintText: 'e.g., Room 1A',
                                  ),
                                ),
                              ),
                              Gap(12),
                              Expanded(
                                child: TextFormField(
                                  controller: _roomRentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Monthly Rent (TZS)',
                                    border: OutlineInputBorder(),
                                    hintText: 'e.g., 150000',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          Gap(12),

                          // Room Type Selection
                          Text(
                            'Room Type:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Gap(12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF3F51B5).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Single Room Option
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRoomType = RoomType.singleRoom;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRoomType ==
                                                  RoomType.singleRoom
                                              ? Color(
                                                0xFF3F51B5,
                                              ).withOpacity(0.1)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            _selectedRoomType ==
                                                    RoomType.singleRoom
                                                ? Color(0xFF3F51B5)
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF3F51B5),
                                              width: 2,
                                            ),
                                            color:
                                                _selectedRoomType ==
                                                        RoomType.singleRoom
                                                    ? Color(0xFF3F51B5)
                                                    : Colors.transparent,
                                          ),
                                          child:
                                              _selectedRoomType ==
                                                      RoomType.singleRoom
                                                  ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        Gap(16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Single Room',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2C3E50),
                                                ),
                                              ),
                                              Text(
                                                'Shared toilet outside',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Divider
                                Divider(
                                  height: 1,
                                  color: Color(0xFF3F51B5).withOpacity(0.2),
                                ),

                                // Self Contained Option
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRoomType =
                                          RoomType.selfContained;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRoomType ==
                                                  RoomType.selfContained
                                              ? Color(
                                                0xFF3F51B5,
                                              ).withOpacity(0.1)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            _selectedRoomType ==
                                                    RoomType.selfContained
                                                ? Color(0xFF3F51B5)
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF3F51B5),
                                              width: 2,
                                            ),
                                            color:
                                                _selectedRoomType ==
                                                        RoomType.selfContained
                                                    ? Color(0xFF3F51B5)
                                                    : Colors.transparent,
                                          ),
                                          child:
                                              _selectedRoomType ==
                                                      RoomType.selfContained
                                                  ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        Gap(16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Self Contained',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2C3E50),
                                                ),
                                              ),
                                              Text(
                                                'Private toilet inside',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Divider
                                Divider(
                                  height: 1,
                                  color: Color(0xFF3F51B5).withOpacity(0.2),
                                ),

                                // Two Rooms Option
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRoomType = RoomType.twoRooms;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRoomType == RoomType.twoRooms
                                              ? Color(
                                                0xFF3F51B5,
                                              ).withOpacity(0.1)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            _selectedRoomType ==
                                                    RoomType.twoRooms
                                                ? Color(0xFF3F51B5)
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF3F51B5),
                                              width: 2,
                                            ),
                                            color:
                                                _selectedRoomType ==
                                                        RoomType.twoRooms
                                                    ? Color(0xFF3F51B5)
                                                    : Colors.transparent,
                                          ),
                                          child:
                                              _selectedRoomType ==
                                                      RoomType.twoRooms
                                                  ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        Gap(16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Two Rooms',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2C3E50),
                                                ),
                                              ),
                                              Text(
                                                'Shared toilet outside',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(12),

                          // Amenities Selection
                          Text(
                            'Amenities:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Gap(8),
                          Wrap(
                            spacing: 8,
                            children:
                                _availableAmenities.map((amenity) {
                                  final isSelected = _selectedAmenities
                                      .contains(amenity);
                                  return FilterChip(
                                    label: Text(amenity),
                                    selected: isSelected,
                                    onSelected:
                                        (selected) => _toggleAmenity(amenity),
                                    selectedColor: Color(
                                      0xFF3F51B5,
                                    ).withOpacity(0.2),
                                    checkmarkColor: Color(0xFF3F51B5),
                                  );
                                }).toList(),
                          ),
                          Gap(16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _addRoom,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Room'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3F51B5),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16),

                    // Rooms List
                    if (_rooms.isNotEmpty) ...[
                      Text(
                        'Added Rooms:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Gap(12),
                      ..._rooms.asMap().entries.map((entry) {
                        final index = entry.key;
                        final room = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFF3F51B5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      room.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    Text(
                                      '${room.typeDescription} - TZS ${room.monthlyRent.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: Color(0xFF7F8C8D),
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (room.amenities.isNotEmpty)
                                      Wrap(
                                        spacing: 4,
                                        children:
                                            room.amenities
                                                .map(
                                                  (amenity) => Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        0xFF3F51B5,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      amenity,
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF3F51B5,
                                                        ),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeRoom(index),
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(0xFFE74C3C),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Gap(16),
                    ],

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _rooms.isEmpty ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xFF2ECC71,
                          ), // Accent: Emerald Green
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Add Property',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProperty = Property(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        rooms: _rooms,
        purchaseDate: _purchaseDate,
        purchasePrice: double.parse(_purchasePriceController.text),
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        ownerEmail: _ownerEmailController.text.trim(),
      );

      Navigator.pop(context, newProperty);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _purchasePriceController.dispose();
    _roomNameController.dispose();
    _roomRentController.dispose();
    super.dispose();
  }
}
