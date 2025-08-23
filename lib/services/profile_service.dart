import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'cloudinary_service.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';
  static const String _profileImageKey = 'profile_image';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user profile data to Firebase
  static Future<bool> saveProfileToFirebase(User user) async {
    try {
      final userData = user.toJson();

      if (user.id != null) {
        // Update existing user
        await _firestore.collection('users').doc(user.id).update(userData);
      } else {
        // Create new user
        final docRef = await _firestore.collection('users').add(userData);
        // Update the user object with the generated ID
        userData['id'] = docRef.id;
      }

      // Also save to local storage as backup
      await saveProfile(user);
      return true;
    } catch (e) {
      print('Error saving profile to Firebase: $e');
      return false;
    }
  }

  // Load user profile data from Firebase
  static Future<User?> loadProfileFromFirebase(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final userData = doc.data()!;
        userData['id'] = doc.id; // Add the document ID
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error loading profile from Firebase: $e');
      return null;
    }
  }

  // Get current user ID (you might want to implement user authentication)
  static String? getCurrentUserId() {
    // For now, return null - you'll need to implement user authentication
    // This could come from Firebase Auth or your authentication system
    return null;
  }

  // Save user profile data (existing local storage method)
  static Future<bool> saveProfile(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = user.toJson();
      await prefs.setString(_profileKey, jsonEncode(userJson));
      return true;
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }

  // Load user profile data (existing local storage method)
  static Future<User?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJsonString = prefs.getString(_profileKey);

      if (userJsonString != null) {
        final userJson = jsonDecode(userJsonString);
        return User.fromJson(userJson);
      }
      return null;
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  // Upload profile image to Cloudinary and update user profile
  static Future<bool> uploadProfileImageAndUpdateUser(
    User user,
    File imageFile,
  ) async {
    try {
      // Upload image to Cloudinary
      final uploadResult = await CloudinaryService.uploadProfileImage(
        imageFile,
      );

      if (uploadResult == null) {
        print('Failed to upload image to Cloudinary');
        return false;
      }

      // Delete old image from Cloudinary if exists
      if (user.profileImagePublicId != null) {
        // Note: You might want to implement image deletion from Cloudinary
        // For now, we'll just update the reference
      }

      // Update user with new Cloudinary data (public ID and URL)
      final updatedUser = user.copyWith(
        profileImagePublicId: uploadResult.publicId,
        profileImageUrl: uploadResult.secureUrl, // Use secure URL
        updatedAt: DateTime.now(),
      );

      // Save updated profile to Firebase
      final success = await saveProfileToFirebase(updatedUser);

      if (success) {
        // Also save locally
        await saveProfile(updatedUser);
      }

      return success;
    } catch (e) {
      print('Error uploading profile image and updating user: $e');
      return false;
    }
  }

  // Get profile image URL from user object (preferred method)
  static String getProfileImageUrl(User user, {int size = 300}) {
    // First try to use the stored URL and resize it
    if (user.profileImageUrl != null &&
        CloudinaryService.isValidCloudinaryUrl(user.profileImageUrl)) {
      return CloudinaryService.getResizedUrl(
        user.profileImageUrl!,
        width: size,
        height: size,
      );
    }

    // Fallback to generating URL from public ID
    if (user.profileImagePublicId != null) {
      return CloudinaryService.getProfileImageUrl(
        user.profileImagePublicId!,
        width: size,
        height: size,
      );
    }

    return ''; // Return empty string if no image
  }

  // Get profile thumbnail URL from user object (preferred method)
  static String getProfileThumbnailUrl(User user, {int size = 100}) {
    // First try to use the stored URL and resize it
    if (user.profileImageUrl != null &&
        CloudinaryService.isValidCloudinaryUrl(user.profileImageUrl)) {
      return CloudinaryService.getThumbnailUrl(
        user.profileImageUrl!,
        size: size,
      );
    }

    // Fallback to generating URL from public ID
    if (user.profileImagePublicId != null) {
      return CloudinaryService.getProfileThumbnailUrl(
        user.profileImagePublicId!,
        size: size,
      );
    }

    return ''; // Return empty string if no image
  }

  // Save profile image to local storage (legacy method - kept for backward compatibility)
  static Future<String?> saveProfileImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/profile_images');

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await imageFile.copy('${imageDir.path}/$fileName');

      return savedImage.path;
    } catch (e) {
      print('Error saving profile image: $e');
      return null;
    }
  }

  // Delete old profile image (legacy method - kept for backward compatibility)
  static Future<void> deleteOldProfileImage(String? oldImagePath) async {
    if (oldImagePath != null) {
      try {
        final oldFile = File(oldImagePath);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (e) {
        print('Error deleting old profile image: $e');
      }
    }
  }

  // Update profile with new image (legacy method - kept for backward compatibility)
  static Future<bool> updateProfileWithImage(
    User user,
    File newImageFile,
  ) async {
    try {
      // Delete old image if exists
      await deleteOldProfileImage(user.profileImagePath);

      // Save new image
      final newImagePath = await saveProfileImage(newImageFile);
      if (newImagePath == null) {
        return false;
      }

      // Update user with new image path
      final updatedUser = user.copyWith(
        profileImagePath: newImagePath,
        updatedAt: DateTime.now(),
      );

      // Save updated profile
      return await saveProfile(updatedUser);
    } catch (e) {
      print('Error updating profile with image: $e');
      return false;
    }
  }

  // Clear all profile data
  static Future<bool> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      return true;
    } catch (e) {
      print('Error clearing profile: $e');
      return false;
    }
  }

  // Check if profile exists
  static Future<bool> hasProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_profileKey);
    } catch (e) {
      print('Error checking profile existence: $e');
      return false;
    }
  }
}
