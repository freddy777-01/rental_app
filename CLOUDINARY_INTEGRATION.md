# Cloudinary Integration for Rental App

This document explains how to use the Cloudinary integration for uploading and displaying user profile images in your rental app.

## Overview

The integration allows you to:

1. Upload profile images to Cloudinary
2. Store the Cloudinary URL and public ID in your User model
3. Save the user data (including the URL) to Firebase
4. Display images from Cloudinary URLs throughout your app

## Setup

### 1. Cloudinary Configuration

The Cloudinary configuration is already set up in `lib/main.dart` with your credentials:

```dart
var cloudinary = Cloudinary.fromStringUrl(
  'cloudinary://816173986778337:FCbIk5L1oy_tGMfrfvRpo-ijuDs@dujga4sq6',
);
```

### 2. Required Packages

The following packages are already installed:

- `cloudinary_url_gen: ^1.8.0` - For URL generation and transformations
- `cloudinary_api: ^1.1.1` - For upload functionality
- `http: ^1.5.0` - For HTTP requests

## Usage

### Uploading Profile Images

Use the `ProfileService.uploadProfileImageAndUpdateUser()` method to upload an image and update the user profile:

```dart
import '../services/profile_service.dart';

// Upload image and update user
final success = await ProfileService.uploadProfileImageAndUpdateUser(
  user,
  imageFile,
);

if (success) {
  print('Image uploaded successfully!');
} else {
  print('Failed to upload image');
}
```

### Displaying Profile Images

#### Option 1: Using ProfileService methods

```dart
import '../services/profile_service.dart';

// Get full-size image URL
final imageUrl = ProfileService.getProfileImageUrl(user, size: 300);

// Get thumbnail URL
final thumbnailUrl = ProfileService.getProfileThumbnailUrl(user, size: 100);

// Display in Image.network
Image.network(imageUrl)
```

#### Option 2: Using the ProfileImageWidget

```dart
import '../widgets/profile_image_widget.dart';

// Full-size profile image
ProfileImageWidget(
  user: user,
  size: 120,
  showBorder: true,
  borderColor: Colors.blue,
)

// Thumbnail version
ProfileThumbnailWidget(
  user: user,
  size: 50,
  showBorder: false,
)
```

### User Model

The User model now includes both `profileImagePublicId` and `profileImageUrl` fields:

```dart
class User {
  final String? id;
  final String name;
  final String phone;
  final String address;
  final String? profileImagePath;        // Legacy local path
  final String? profileImagePublicId;    // Cloudinary public ID
  final String? profileImageUrl;         // Full Cloudinary URL
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ... rest of the model
}
```

## How It Works

### 1. Image Upload Flow

1. User selects an image in the profile screen
2. Image is uploaded to Cloudinary using HTTP POST
3. Cloudinary returns a public ID, URL, and secure URL
4. Both public ID and secure URL are stored in the User model
5. User data (including URLs) is saved to Firebase
6. User data is also saved locally as backup

### 2. Image Display Flow

1. App checks if user has a `profileImageUrl`
2. If yes, uses the stored URL and applies transformations for different sizes
3. If no URL, falls back to generating URL from `profileImagePublicId`
4. Displays image using `Image.network`
5. If no image data, shows default person icon

### 3. URL Generation

Cloudinary URLs are generated with transformations for optimal display:

- `c_fill` - Crop to fill the specified dimensions
- `w_300,h_300` - Width and height
- `q_auto` - Automatic quality optimization

Example URLs:

```
Original: https://res.cloudinary.com/dujga4sq6/image/upload/v1234567890/profile_1234567890.jpg
Resized: https://res.cloudinary.com/dujga4sq6/image/upload/c_fill,w_300,h_300,q_auto/profile_1234567890.jpg
```

## Error Handling

The integration includes comprehensive error handling:

- **Upload failures**: Logged and user notified
- **Network errors**: Graceful fallback to default icons
- **Invalid URLs**: Empty string returned for URLs
- **Loading states**: Progress indicators during uploads

## Security Considerations

- **Upload Preset**: Uses `ml_default` preset (configure in Cloudinary console)
- **Folder Structure**: Images organized in `rental_app/profile_images` folder
- **Public IDs**: Unique IDs generated with timestamps
- **Overwrite**: Enabled to prevent duplicate images
- **Secure URLs**: Uses HTTPS URLs for better security

## Customization

### Changing Image Quality

```dart
// In CloudinaryService.getResizedUrl()
final transformations = 'c_fill,w_$width,h_$height,q_80'; // Fixed quality
```

### Adding More Transformations

```dart
// Add effects, filters, etc.
final transformations = 'c_fill,w_$width,h_$height,q_$quality,e_grayscale';
```

### Custom Upload Preset

```dart
// In CloudinaryService
static const String _uploadPreset = 'your_custom_preset';
```

## Troubleshooting

### Common Issues

1. **Upload fails**: Check Cloudinary credentials and upload preset
2. **Images not displaying**: Verify URL is stored correctly in user object
3. **Slow loading**: Consider adding caching or using thumbnails
4. **Permission errors**: Ensure camera/photos permissions are granted

### Debug Information

Enable debug logging by checking console output for:

- Upload success/failure messages
- Generated Cloudinary URLs
- Error details during operations

## Migration from Local Storage

If you're migrating from local image storage:

1. Existing `profileImagePath` field is preserved for backward compatibility
2. New images use `profileImageUrl` and `profileImagePublicId` for Cloudinary
3. Legacy methods still work but are marked as deprecated
4. Gradually migrate existing users to Cloudinary

## Performance Tips

1. **Use thumbnails** for lists and small displays
2. **Cache URLs** to avoid regenerating them repeatedly
3. **Lazy load** images when they come into view
4. **Optimize sizes** based on display requirements
5. **Store URLs** to avoid URL generation overhead

## Data Structure in Firebase

Your user documents in Firebase will now include:

```json
{
	"id": "user123",
	"name": "John Doe",
	"phone": "+1234567890",
	"address": "123 Main St",
	"profileImagePath": null,
	"profileImagePublicId": "rental_app/profile_images/profile_1234567890",
	"profileImageUrl": "https://res.cloudinary.com/dujga4sq6/image/upload/v1234567890/rental_app/profile_images/profile_1234567890.jpg",
	"createdAt": "2024-01-01T00:00:00.000Z",
	"updatedAt": "2024-01-01T00:00:00.000Z"
}
```

## Support

For Cloudinary-specific issues, refer to:

- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Dart SDK Reference](https://cloudinary.com/documentation/dart_quick_start)
- [Upload API Reference](https://cloudinary.com/documentation/upload_images)
