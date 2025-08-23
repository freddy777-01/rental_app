import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudinary_url_gen/cloudinary.dart';

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
  static final Cloudinary _cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://816173986778337:FCbIk5L1oy_tGMfrfvRpo-ijuDs@dujga4sq6',
  );

  // Your Cloudinary credentials
  static const String _cloudName = 'dujga4sq6';
  static const String _apiKey = '816173986778337';
  static const String _apiSecret = 'FCbIk5L1oy_tGMfrfvRpo-ijuDs';
  static const String _uploadPreset = 'ml_default'; // Use your upload preset

  /// Upload image to Cloudinary and return the upload result
  static Future<CloudinaryUploadResult?> uploadProfileImage(
    File imageFile,
  ) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();

      // Create upload URL
      final uploadUrl =
          'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

      // Create form data
      final request =
          http.MultipartRequest('POST', Uri.parse(uploadUrl))
            ..fields['upload_preset'] = _uploadPreset
            ..fields['folder'] = 'rental_app/profile_images'
            ..fields['public_id'] =
                'profile_${DateTime.now().millisecondsSinceEpoch}'
            ..fields['overwrite'] = 'true';

      // Add the image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'profile_image.jpg',
        ),
      );

      // Send the request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return CloudinaryUploadResult(
          publicId: jsonData['public_id'],
          url: jsonData['url'],
          secureUrl: jsonData['secure_url'],
        );
      } else {
        print('Upload failed: ${jsonData['error']}');
        return null;
      }
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  /// Generate a URL for a profile image using the public ID
  static String getProfileImageUrl(
    String publicId, {
    int width = 300,
    int height = 300,
    String quality = 'auto',
  }) {
    try {
      // Simple URL generation with transformations
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
      // Insert transformations into the URL
      final parts = baseUrl.split('/upload/');
      if (parts.length == 2) {
        final transformations = 'c_fill,w_$width,h_$height,q_auto';
        return '${parts[0]}/upload/$transformations/${parts[1]}';
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
