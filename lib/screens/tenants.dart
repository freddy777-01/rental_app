import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/tenant.dart';
import '../models/property.dart';
import '../services/tenant_service.dart';
import '../services/property_service.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTenantsFromFirebase();
  }

  Future<void> _loadTenantsFromFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tenants = await TenantService.fetchTenants();
      setState(() {
        _allTenants.clear();
        _allTenants.addAll(tenants);
        _filteredTenants = _allTenants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading tenants: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                      tenant.name.toLowerCase().contains(query.toLowerCase()) ||
                      tenant.phone.toLowerCase().contains(query.toLowerCase()),
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
    ).then((newTenant) async {
      if (newTenant != null) {
        // Save to Firebase
        final success = await TenantService.saveTenant(newTenant);

        if (success) {
          // Reload tenants from Firebase
          await _loadTenantsFromFirebase();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newTenant.name} added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save tenant. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
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
                onPressed: () async {
                  Navigator.pop(context);

                  // Delete from Firebase
                  final success = await TenantService.deleteTenant(tenant.id!);

                  if (success) {
                    // Reload tenants from Firebase
                    await _loadTenantsFromFirebase();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${tenant.name} deleted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to delete tenant. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
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

  void _unassignTenant(Tenant tenant) {
    if (tenant.propertyId == null || tenant.partitionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tenant is not assigned to any partition.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unassign Tenant'),
            content: Text(
              'Are you sure you want to unassign ${tenant.name} from ${tenant.partitionName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  // Unassign tenant from partition
                  final success =
                      await PropertyService.unassignTenantFromPartition(
                        tenant.propertyId!,
                        tenant.partitionId!,
                      );

                  if (success) {
                    // Update tenant with move-out date
                    final updatedTenant = tenant.copyWith(
                      moveOutDate: DateTime.now(),
                      isActive: false,
                      updatedAt: DateTime.now(),
                    );

                    final tenantUpdateSuccess =
                        await TenantService.updateTenant(updatedTenant);

                    if (tenantUpdateSuccess) {
                      // Reload tenants from Firebase
                      await _loadTenantsFromFirebase();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${tenant.name} unassigned successfully!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to update tenant. Please try again.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to unassign tenant. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Unassign',
                  style: TextStyle(color: Colors.orange),
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
            child: SizedBox(
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
                                        color: Colors.grey.withValues(
                                          alpha: 0.3,
                                        ),
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
                                    color: Colors.grey.withValues(alpha: 0.5),
                                  ),
                                  Gap(16),
                                  Text(
                                    'No contract pages available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.withValues(alpha: 0.7),
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
                                      : Colors.grey.withValues(alpha: 0.3),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTenantsFromFirebase,
            tooltip: 'Refresh Tenants',
          ),
        ],
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
                  hintText: 'Search tenants by name or phone...',
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
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredTenants.isEmpty
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
                                  color: Colors.grey.withValues(alpha: 0.3),
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
                                  Icons.person,
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
                                      Expanded(
                                        child: Text(
                                          tenant.phone,
                                          style: TextStyle(
                                            color: Color(0xFF7F8C8D),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                      Expanded(
                                        child: Text(
                                          '${tenant.propertyName} - ${tenant.partitionName ?? "No Partition"}',
                                          style: TextStyle(
                                            color: Color(0xFF7F8C8D),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                      Expanded(
                                        child: Text(
                                          'TZS ${tenant.rentAmount.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            color: Color(0xFF7F8C8D),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(2),
                                  Row(
                                    children: [
                                      Icon(
                                        tenant.isActive
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        size: 16,
                                        color:
                                            tenant.isActive
                                                ? Color(0xFF2ECC71)
                                                : Color(0xFFE74C3C),
                                      ),
                                      Gap(4),
                                      Expanded(
                                        child: Text(
                                          tenant.isActive
                                              ? 'Active'
                                              : 'Inactive',
                                          style: TextStyle(
                                            color:
                                                tenant.isActive
                                                    ? Color(0xFF2ECC71)
                                                    : Color(0xFFE74C3C),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                          if (tenant.isActive &&
                                              tenant.propertyId != null &&
                                              tenant.partitionId != null)
                                            PopupMenuItem(
                                              value: 'unassign',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.logout,
                                                    color: Colors.orange,
                                                  ),
                                                  Gap(8),
                                                  Text('Unassign'),
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
                                      if (value == 'unassign') {
                                        _unassignTenant(tenant);
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
  final _rentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _contractPages = []; // Multiple contract pages
  final ImagePicker _picker = ImagePicker();

  // Property and partition selection
  List<Property> _properties = [];
  Property? _selectedProperty;
  Partition? _selectedPartition;
  bool _isLoadingProperties = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoadingProperties = true;
    });

    try {
      final properties = await PropertyService.fetchProperties();
      setState(() {
        _properties = properties;
        _isLoadingProperties = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProperties = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading properties: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onPropertyChanged(Property? property) {
    setState(() {
      _selectedProperty = property;
      _selectedPartition = null; // Reset partition selection
    });
  }

  void _onPartitionChanged(Partition? partition) {
    setState(() {
      _selectedPartition = partition;
      if (partition != null) {
        _rentController.text = partition.monthlyRent.toString();
      }
    });
  }

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

                    // Property Selection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF3F51B5).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Property & Partition Selection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Gap(12),

                          // Property Dropdown
                          DropdownButtonFormField<Property>(
                            value: _selectedProperty,
                            decoration: const InputDecoration(
                              labelText: 'Select Property *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                            ),
                            items:
                                _properties.map((property) {
                                  return DropdownMenuItem(
                                    value: property,
                                    child: Text(property.name),
                                  );
                                }).toList(),
                            onChanged: _onPropertyChanged,
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a property';
                              }
                              return null;
                            },
                          ),
                          Gap(12),

                          // Partition Dropdown
                          if (_selectedProperty != null) ...[
                            DropdownButtonFormField<Partition>(
                              value: _selectedPartition,
                              decoration: const InputDecoration(
                                labelText: 'Select Available Partition *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.room),
                              ),
                              items:
                                  _selectedProperty!.availablePartitionsList.map((
                                    partition,
                                  ) {
                                    return DropdownMenuItem(
                                      value: partition,
                                      child: Text(
                                        '${partition.name} - TZS ${partition.monthlyRent.toStringAsFixed(0)}',
                                      ),
                                    );
                                  }).toList(),
                              onChanged: _onPartitionChanged,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a partition';
                                }
                                return null;
                              },
                            ),
                            Gap(8),
                            if (_selectedProperty!
                                .availablePartitionsList
                                .isEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange),
                                    Gap(8),
                                    Expanded(
                                      child: Text(
                                        'No available partitions in this property',
                                        style: TextStyle(color: Colors.orange),
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
                    Gap(16),

                    // Contract Document Capture Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF3F51B5).withValues(alpha: 0.3),
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
                                'Contract Document (Optional)',
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
                            SizedBox(
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
                                          color: Colors.grey.withValues(
                                            alpha: 0.3,
                                          ),
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
                                              color: Colors.black.withValues(
                                                alpha: 0.7,
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
                                  color: Color(
                                    0xFF3F51B5,
                                  ).withValues(alpha: 0.2),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProperty == null || _selectedPartition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a property and partition'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newTenant = Tenant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        propertyName: _selectedProperty!.name,
        propertyId: _selectedProperty!.id,
        partitionId: _selectedPartition!.id,
        partitionName: _selectedPartition!.name,
        rentAmount: double.parse(_rentController.text),
        moveInDate: _selectedDate,
        contractPages: _contractPages.isEmpty ? null : _contractPages,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save tenant to Firebase
      final tenantSuccess = await TenantService.saveTenant(newTenant);

      if (tenantSuccess) {
        // Assign tenant to partition
        final partitionSuccess = await PropertyService.assignTenantToPartition(
          _selectedProperty!.id!,
          _selectedPartition!.id,
          newTenant.id!,
          newTenant.name,
        );

        if (partitionSuccess) {
          Navigator.pop(context, newTenant);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Tenant saved but failed to assign to partition. Please try again.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save tenant. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _rentController.dispose();
    super.dispose();
  }
}
