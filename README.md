# Rental App

A Flutter application for managing rental properties, tenants, and user profiles.

## Features

### Profile Management

- **Profile Photo Upload**: Users can upload profile photos from camera or gallery
- **Personal Information**: Users can enter and save their full name and address
- **Data Persistence**: Profile data is saved locally using SharedPreferences
- **Image Storage**: Profile images are stored in the app's local directory

### How to Use the Profile Feature

1. **Access Profile**: Tap the "Profile" tab in the bottom navigation bar
2. **Upload Photo**:
   - Tap the profile photo circle to open image source dialog
   - Choose between Camera or Gallery
   - The image will be automatically resized and optimized
3. **Enter Information**:
   - Fill in your full name in the "Full Name" field
   - Enter your complete address in the "Address" field
4. **Save Profile**: Tap the "Save Profile" button to persist your data

### Technical Details

#### Dependencies Used

- `image_picker`: For selecting images from camera or gallery
- `permission_handler`: For requesting camera and storage permissions
- `shared_preferences`: For local data persistence
- `path_provider`: For managing file storage

#### File Structure

```
lib/
├── models/
│   └── user.dart              # User model for profile data
├── screens/
│   └── profile.dart           # Profile screen UI and logic
├── services/
│   └── profile_service.dart   # Profile data management service
└── main.dart                  # App entry point
```

#### Data Model

The `User` model includes:

- `id`: Unique identifier
- `name`: User's full name
- `address`: User's complete address
- `profileImagePath`: Path to stored profile image
- `createdAt`: Profile creation timestamp
- `updatedAt`: Last update timestamp

#### Storage

- Profile data is stored using SharedPreferences
- Images are saved in the app's documents directory under `/profile_images/`
- Old images are automatically cleaned up when new ones are uploaded

### Permissions Required

- Camera: For taking profile photos
- Storage: For accessing gallery and saving images

### Error Handling

- Graceful handling of permission denials
- Error messages for failed operations
- Loading states during image processing and data saving

## Getting Started

1. Ensure you have Flutter installed
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Notes

- The app requires camera and storage permissions to function properly
- Profile data is stored locally on the device
- Images are optimized for size and quality before storage
