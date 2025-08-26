import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tenant.dart';

class TenantService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'tenants';

  // Save new tenant to Firebase
  static Future<bool> saveTenant(Tenant tenant) async {
    try {
      final tenantData = tenant.toJson();

      // Check if tenant with same phone already exists
      final existingTenantQuery =
          await _firestore
              .collection(_collectionName)
              .where('phone', isEqualTo: tenant.phone)
              .limit(1)
              .get();

      if (existingTenantQuery.docs.isNotEmpty) {
        // Tenant exists, update the existing document
        final existingDoc = existingTenantQuery.docs.first;
        final existingTenantId = existingDoc.id;

        // Update the tenant object with the existing ID
        final updatedTenantData = tenantData;
        updatedTenantData['id'] = existingTenantId;

        // Update the existing document
        await _firestore
            .collection(_collectionName)
            .doc(existingTenantId)
            .update(updatedTenantData);
      } else {
        // Tenant doesn't exist, create new document
        if (tenant.id != null) {
          // Use the provided ID if available
          await _firestore
              .collection(_collectionName)
              .doc(tenant.id)
              .set(tenantData);
        } else {
          // Create new document with auto-generated ID
          final docRef = await _firestore
              .collection(_collectionName)
              .add(tenantData);
          // Update the tenant object with the generated ID
          tenantData['id'] = docRef.id;
        }
      }

      return true;
    } catch (e) {
      print('Error saving tenant to Firebase: $e');
      return false;
    }
  }

  // Update existing tenant
  static Future<bool> updateTenant(Tenant tenant) async {
    try {
      if (tenant.id == null) {
        print('Tenant ID is null, cannot update');
        return false;
      }

      final tenantData = tenant.toJson();
      await _firestore
          .collection(_collectionName)
          .doc(tenant.id)
          .update(tenantData);
      return true;
    } catch (e) {
      print('Error updating tenant in Firebase: $e');
      return false;
    }
  }

  // Fetch all tenants from Firebase
  static Future<List<Tenant>> fetchTenants() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      final tenants = <Tenant>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to data
        tenants.add(Tenant.fromJson(data));
      }

      return tenants;
    } catch (e) {
      print('Error fetching tenants from Firebase: $e');
      return [];
    }
  }

  // Fetch tenant by ID
  static Future<Tenant?> fetchTenantById(String tenantId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(tenantId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        data['id'] = docSnapshot.id;
        return Tenant.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error fetching tenant by ID from Firebase: $e');
      return null;
    }
  }

  // Delete tenant
  static Future<bool> deleteTenant(String tenantId) async {
    try {
      await _firestore.collection(_collectionName).doc(tenantId).delete();
      return true;
    } catch (e) {
      print('Error deleting tenant from Firebase: $e');
      return false;
    }
  }

  // Search tenants by name or phone
  static Future<List<Tenant>> searchTenants(String query) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionName)
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThan: query + '\uf8ff')
              .get();

      final tenants = <Tenant>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        tenants.add(Tenant.fromJson(data));
      }

      return tenants;
    } catch (e) {
      print('Error searching tenants in Firebase: $e');
      return [];
    }
  }

  // Fetch tenants by property ID
  static Future<List<Tenant>> fetchTenantsByProperty(String propertyId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionName)
              .where('propertyId', isEqualTo: propertyId)
              .get();

      final tenants = <Tenant>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        tenants.add(Tenant.fromJson(data));
      }

      return tenants;
    } catch (e) {
      print('Error fetching tenants by property from Firebase: $e');
      return [];
    }
  }

  // Fetch tenants by partition ID
  static Future<List<Tenant>> fetchTenantsByPartition(
    String partitionId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionName)
              .where('partitionId', isEqualTo: partitionId)
              .get();

      final tenants = <Tenant>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        tenants.add(Tenant.fromJson(data));
      }

      return tenants;
    } catch (e) {
      print('Error fetching tenants by partition from Firebase: $e');
      return [];
    }
  }
}

