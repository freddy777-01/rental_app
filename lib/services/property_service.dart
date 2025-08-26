import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';

class PropertyService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'properties';

  // Save new property to Firebase
  static Future<bool> saveProperty(Property property) async {
    try {
      final propertyData = property.toJson();

      // Check if property with same name already exists
      final existingPropertyQuery =
          await _firestore
              .collection(_collectionName)
              .where('name', isEqualTo: property.name)
              .limit(1)
              .get();

      if (existingPropertyQuery.docs.isNotEmpty) {
        // Property exists, update the existing document
        final existingDoc = existingPropertyQuery.docs.first;
        final existingPropertyId = existingDoc.id;

        // Update the property object with the existing ID
        final updatedPropertyData = propertyData;
        updatedPropertyData['id'] = existingPropertyId;

        // Update the existing document
        await _firestore
            .collection(_collectionName)
            .doc(existingPropertyId)
            .update(updatedPropertyData);
      } else {
        // Property doesn't exist, create new document
        if (property.id != null) {
          // Use the provided ID if available
          await _firestore
              .collection(_collectionName)
              .doc(property.id)
              .set(propertyData);
        } else {
          // Create new document with auto-generated ID
          final docRef = await _firestore
              .collection(_collectionName)
              .add(propertyData);
          // Update the property object with the generated ID
          propertyData['id'] = docRef.id;
        }
      }

      return true;
    } catch (e) {
      print('Error saving property to Firebase: $e');
      return false;
    }
  }

  // Update existing property
  static Future<bool> updateProperty(Property property) async {
    try {
      if (property.id == null) {
        print('Property ID is null, cannot update');
        return false;
      }

      final propertyData = property.toJson();
      await _firestore
          .collection(_collectionName)
          .doc(property.id)
          .update(propertyData);
      return true;
    } catch (e) {
      print('Error updating property in Firebase: $e');
      return false;
    }
  }

  // Fetch all properties from Firebase
  static Future<List<Property>> fetchProperties() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      final properties = <Property>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to data
        properties.add(Property.fromJson(data));
      }

      return properties;
    } catch (e) {
      print('Error fetching properties from Firebase: $e');
      return [];
    }
  }

  // Fetch property by ID
  static Future<Property?> fetchPropertyById(String propertyId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(propertyId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        data['id'] = docSnapshot.id;
        return Property.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error fetching property by ID from Firebase: $e');
      return null;
    }
  }

  // Delete property
  static Future<bool> deleteProperty(String propertyId) async {
    try {
      await _firestore.collection(_collectionName).doc(propertyId).delete();
      return true;
    } catch (e) {
      print('Error deleting property from Firebase: $e');
      return false;
    }
  }

  // Search properties by name or address
  static Future<List<Property>> searchProperties(String query) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionName)
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThan: query + '\uf8ff')
              .get();

      final properties = <Property>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        properties.add(Property.fromJson(data));
      }

      return properties;
    } catch (e) {
      print('Error searching properties in Firebase: $e');
      return [];
    }
  }

  // Assign tenant to partition
  static Future<bool> assignTenantToPartition(
    String propertyId,
    String partitionId,
    String tenantId,
    String tenantName,
  ) async {
    try {
      final property = await fetchPropertyById(propertyId);
      if (property == null) {
        print('Property not found');
        return false;
      }

      final updatedProperty = property.assignTenantToPartition(
        partitionId,
        tenantId,
        tenantName,
      );
      return await updateProperty(updatedProperty);
    } catch (e) {
      print('Error assigning tenant to partition: $e');
      return false;
    }
  }

  // Unassign tenant from partition
  static Future<bool> unassignTenantFromPartition(
    String propertyId,
    String partitionId,
  ) async {
    try {
      final property = await fetchPropertyById(propertyId);
      if (property == null) {
        print('Property not found');
        return false;
      }

      final updatedProperty = property.unassignTenantFromPartition(partitionId);
      return await updateProperty(updatedProperty);
    } catch (e) {
      print('Error unassigning tenant from partition: $e');
      return false;
    }
  }
}
