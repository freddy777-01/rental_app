import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/property.dart';

class Tenant {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String propertyName;
  final String? propertyId;
  final String? roomId;
  final String? roomName;
  final double rentAmount;
  final DateTime moveInDate;
  final DateTime? moveOutDate;
  final bool isActive;
  final List<String>? contractPages; // Multiple contract pages

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.propertyName,
    this.propertyId,
    this.roomId,
    this.roomName,
    required this.rentAmount,
    required this.moveInDate,
    this.moveOutDate,
    this.isActive = true,
    this.contractPages,
  });
}

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Tenant> _allTenants = [];
  List<Tenant> _filteredTenants = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSampleTenants();
    _filteredTenants = _allTenants;
  }

  void _loadSampleTenants() {
    _allTenants.addAll([
      Tenant(
        id: '1',
        name: 'Reginald Raymond',
        phone: '+255 123 456 789',
        email: 'reginald@email.com',
        propertyName: 'Sunset Apartments',
        propertyId: '1',
        roomId: '1',
        roomName: 'Room 1A',
        rentAmount: 150000,
        moveInDate: DateTime(2024, 1, 15),
        contractPages: null,
      ),
      Tenant(
        id: '2',
        name: 'Heyday Dismiss',
        phone: '+255 987 654 321',
        email: 'heyday@email.com',
        propertyName: 'Sunset Apartments',
        propertyId: '1',
        roomId: '3',
        roomName: 'Room 2A',
        rentAmount: 120000,
        moveInDate: DateTime(2024, 2, 1),
        contractPages: null,
      ),
      Tenant(
        id: '3',
        name: 'Henna Sinbad',
        phone: '+255 555 123 456',
        email: 'henna@email.com',
        propertyName: 'Green Valley House',
        propertyId: '2',
        roomId: '4',
        roomName: 'Main Unit',
        rentAmount: 80000,
        moveInDate: DateTime(2024, 3, 10),
        contractPages: null,
      ),
    ]);
  }

  void _filterTenants(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTenants = _allTenants;
        _isSearching = false;
      } else {
        _filteredTenants =
            _allTenants
                .where(
                  (tenant) =>
                      tenant.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
        _isSearching = true;
      }
    });
  }

  void _addTenant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTenantForm(),
    ).then((newTenant) {
      if (newTenant != null) {
        setState(() {
          _allTenants.add(newTenant);
          _filteredTenants = _allTenants;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newTenant.name} added successfully!')),
        );
      }
    });
  }

  void _deleteTenant(Tenant tenant) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Tenant'),
            content: Text('Are you sure you want to delete ${tenant.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _allTenants.remove(tenant);
                    _filteredTenants = _allTenants;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${tenant.name} deleted successfully!'),
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

  void _viewContract(Tenant tenant) {
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
                        Text(
                          '${tenant.name}\'s Contract',
                          style: const TextStyle(
                            fontSize: 18,
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

                  // Contract Pages
                  Expanded(
                    child:
                        tenant.contractPages != null &&
                                tenant.contractPages!.isNotEmpty
                            ? PageView.builder(
                              itemCount: tenant.contractPages!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Page Header
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F6FA),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(8),
                                              ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Page ${index + 1} of ${tenant.contractPages!.length}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF2C3E50),
                                              ),
                                            ),
                                            Icon(
                                              Icons.description,
                                              color: Color(0xFF3F51B5),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Page Image
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                bottom: Radius.circular(8),
                                              ),
                                          child: Image.file(
                                            File(tenant.contractPages![index]),
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 64,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  Gap(16),
                                  Text(
                                    'No contract pages available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),

                  // Page Indicator
                  if (tenant.contractPages != null &&
                      tenant.contractPages!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          tenant.contractPages!.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  index == 0
                                      ? Color(0xFF3F51B5)
                                      : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenants'),
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
                onChanged: _filterTenants,
                decoration: InputDecoration(
                  hintText: 'Search tenants by name...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _isSearching
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterTenants('');
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

            // Tenants List
            Expanded(
              child:
                  _filteredTenants.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSearching
                                  ? Icons.search_off
                                  : Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            Gap(16),
                            Text(
                              _isSearching
                                  ? 'No tenants found matching your search'
                                  : 'No tenants added yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!_isSearching) ...[
                              Gap(16),
                              ElevatedButton.icon(
                                onPressed: _addTenant,
                                icon: const Icon(Icons.add),
                                label: const Text('Add First Tenant'),
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
                        itemCount: _filteredTenants.length,
                        itemBuilder: (context, index) {
                          final tenant = _filteredTenants[index];
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
                                  Icons.description,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                tenant.name,
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
                                        Icons.phone,
                                        size: 16,
                                        color: Color(
                                          0xFF7F8C8D,
                                        ), // Text: Secondary
                                      ),
                                      Gap(4),
                                      Text(
                                        tenant.phone,
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
                                        Icons.home,
                                        size: 16,
                                        color: Color(
                                          0xFF7F8C8D,
                                        ), // Text: Secondary
                                      ),
                                      Gap(4),
                                      Text(
                                        '${tenant.propertyName} - ${tenant.roomName ?? "No Room"}',
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
                                        'TZS ${tenant.rentAmount.toStringAsFixed(0)}',
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
                                  if (tenant.contractPages?.isNotEmpty == true)
                                    IconButton(
                                      onPressed: () => _viewContract(tenant),
                                      icon: Icon(
                                        Icons.description,
                                        color: Color(0xFF3F51B5),
                                      ),
                                      tooltip:
                                          'View Contract (${tenant.contractPages?.length ?? 0} pages)',
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
                                        _deleteTenant(tenant);
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
        onPressed: _addTenant,
        backgroundColor: Color(0xFF2ECC71), // Accent: Emerald Green
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Tenant'),
      ),
    );
  }
}

class AddTenantForm extends StatefulWidget {
  const AddTenantForm({super.key});

  @override
  State<AddTenantForm> createState() => _AddTenantFormState();
}

class _AddTenantFormState extends State<AddTenantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _propertyController = TextEditingController();
  final _rentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _contractPages = []; // Multiple contract pages
  final ImagePicker _picker = ImagePicker();

  Future<void> _takeContractPage() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to take photos'),
        ),
      );
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _contractPages.add(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _contractPages.add(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _removeContractPage(int index) {
    setState(() {
      _contractPages.removeAt(index);
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
                  'Add New Tenant',
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
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tenant name';
                        }
                        return null;
                      },
                    ),
                    Gap(16),

                    // Contract Document Capture Section
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contract Document',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              Text(
                                '${_contractPages.length} page${_contractPages.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7F8C8D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Gap(12),

                          // Contract Pages Display
                          if (_contractPages.isNotEmpty) ...[
                            Container(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _contractPages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 12),
                                    width: 80,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color(0xFF3F51B5),
                                        width: 1,
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
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          child: Image.file(
                                            File(_contractPages[index]),
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 120,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE74C3C),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              onPressed:
                                                  () => _removeContractPage(
                                                    index,
                                                  ),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(
                                                minWidth: 24,
                                                minHeight: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4,
                                          left: 4,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Page ${index + 1}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Gap(16),
                          ],

                          // Capture Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _takeContractPage,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Add Page'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3F51B5),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              Gap(12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _pickFromGallery,
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('From Gallery'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF3F51B5),
                                    side: BorderSide(color: Color(0xFF3F51B5)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (_contractPages.isEmpty) ...[
                            Gap(12),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFF3F51B5).withOpacity(0.2),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF3F51B5),
                                    size: 20,
                                  ),
                                  Gap(8),
                                  Expanded(
                                    child: Text(
                                      'Take photos of all contract pages. You can add multiple pages and reorder them as needed.',
                                      style: TextStyle(
                                        color: Color(0xFF7F8C8D),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Gap(16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    Gap(16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(16),
                    TextFormField(
                      controller: _propertyController,
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
                      controller: _rentController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Rent (TZS) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter rent amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    Gap(16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Move-in Date *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                      ),
                    ),
                    Gap(32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xFF2ECC71,
                          ), // Accent: Emerald Green
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Add Tenant',
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
      final newTenant = Tenant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        propertyName: _propertyController.text.trim(),
        rentAmount: double.parse(_rentController.text),
        moveInDate: _selectedDate,
        contractPages: _contractPages.isEmpty ? null : _contractPages,
      );

      Navigator.pop(context, newTenant);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _propertyController.dispose();
    _rentController.dispose();
    super.dispose();
  }
}
