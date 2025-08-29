import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/transformation/effect/effect.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:rental_app/models/user.dart';

/// Upload result containing both public ID and URL
class CloudinaryUploadResult {
  final String publicId;
  final String url;
  final String secureUrl;

  CloudinaryUploadResult({
    required this.publicId,
    required this.url,
    required this.secureUrl,
  });
}

class CloudinaryService {
  // Your Cloudinary credentials
  // static const String _cloudName = 'dujga4sq6';
  // static const String _uploadPreset = 'ml_default'; // Use your upload preset
  static const String _API_KEY = "816173986778337";
  static const String _API_SECRET = "FCbIk5L1oy_tGMfrfvRpo-ijuDs";
  static const String _CLOUD_NAME = "dujga4sq6";

  static final Cloudinary cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://$_API_KEY:$_API_SECRET@$_CLOUD_NAME',
  );

  /// Upload image to Cloudinary using HTTP (reliable method)
  static Future<Map<String, dynamic>?> uploadProfileImage(
    File imageFile,
    User user,
  ) async {
    cloudinary.config.urlConfig.secure = true;
    bool saved = false;

    try {
      // Convert image to bytes
      // final imageBytes = await imageFile.readAsBytes();

      // Create upload URL

      final response = await cloudinary.uploader().upload(
        imageFile,
        params: UploadParams(
          publicId: "${user.name}_${user.phone}",
          uniqueFilename: true,
          overwrite: true,
          resourceType: "image",
          folder: "profile_images/${user.name}_${user.phone}",
        ),
        completion:
            (response) => {
              if (response.responseCode == 200)
                {print('Upload successful: ${response.data}')}
              else
                {print('*****Upload failed: ${response.error}')},
            },
      );

      // print('*****response: ${response?.responseCode}');

      return <String, dynamic>{
        "response": response?.responseCode == 200 ? true : false,
        "publicId": response?.data?.publicId,
        "url": response?.data?.secureUrl,
        "secureUrl": response?.data?.secureUrl,
      };
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }
  // End of image upload

  /// Generate a URL for a profile image using the public ID with transformations
  static String getProfileImageUrl(
    String publicId, {
    int width = 300,
    int height = 300,
    String quality = 'auto',
  }) {
    try {
      // Manual URL generation with transformations (reliable method)
      final baseUrl = 'https://res.cloudinary.com/$_cloudName/image/upload';
      final transformations = 'c_fill,w_$width,h_$height,q_$quality';
      return '$baseUrl/$transformations/$publicId';
    } catch (e) {
      print('Error generating Cloudinary URL: $e');
      return '';
    }
  }

  /// Generate a thumbnail URL for profile images
  static String getProfileThumbnailUrl(String publicId, {int size = 100}) {
    return getProfileImageUrl(publicId, width: size, height: size);
  }

  /// Generate different sized URLs from a base Cloudinary URL
  static String getResizedUrl(
    String baseUrl, {
    int width = 300,
    int height = 300,
  }) {
    try {
      // Extract public ID from the base URL
      final parts = baseUrl.split('/upload/');
      if (parts.length == 2) {
        final publicId = parts[1];
        return getProfileImageUrl(publicId, width: width, height: height);
      }
      return baseUrl;
    } catch (e) {
      print('Error generating resized URL: $e');
      return baseUrl;
    }
  }

  /// Generate thumbnail URL from a base Cloudinary URL
  static String getThumbnailUrl(String baseUrl, {int size = 100}) {
    return getResizedUrl(baseUrl, width: size, height: size);
  }

  /// Check if a public ID is valid
  static bool isValidPublicId(String? publicId) {
    return publicId != null && publicId.isNotEmpty;
  }

  /// Check if a URL is a valid Cloudinary URL
  static bool isValidCloudinaryUrl(String? url) {
    return url != null && url.isNotEmpty && url.contains('cloudinary.com');
  }
}
