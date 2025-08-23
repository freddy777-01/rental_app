import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/profile_service.dart';

class ProfileImageWidget extends StatelessWidget {
  final User user;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ProfileImageWidget({
    super.key,
    required this.user,
    this.size = 100,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? Theme.of(context).primaryColor;

    // First try to use the stored Cloudinary URL
    if (user.profileImageUrl != null) {
      final imageUrl = ProfileService.getProfileImageUrl(
        user,
        size: size.toInt(),
      );

      if (imageUrl.isNotEmpty) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                showBorder
                    ? Border.all(
                      color: effectiveBorderColor,
                      width: borderWidth,
                    )
                    : null,
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder ??
                    Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
              },
              errorBuilder: (context, error, stackTrace) {
                return errorWidget ??
                    Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: size * 0.4,
                        color: Colors.grey[600],
                      ),
                    );
              },
            ),
          ),
        );
      }
    }

    // Fallback to default icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            showBorder
                ? Border.all(color: effectiveBorderColor, width: borderWidth)
                : null,
        color: Colors.grey[300],
      ),
      child: Icon(Icons.person, size: size * 0.4, color: Colors.grey[600]),
    );
  }
}

// Thumbnail version for smaller displays
class ProfileThumbnailWidget extends StatelessWidget {
  final User user;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const ProfileThumbnailWidget({
    super.key,
    required this.user,
    this.size = 50,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? Theme.of(context).primaryColor;

    // First try to use the stored Cloudinary URL
    if (user.profileImageUrl != null) {
      final imageUrl = ProfileService.getProfileThumbnailUrl(
        user,
        size: size.toInt(),
      );

      if (imageUrl.isNotEmpty) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                showBorder
                    ? Border.all(
                      color: effectiveBorderColor,
                      width: borderWidth,
                    )
                    : null,
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: SizedBox(
                      width: size * 0.3,
                      height: size * 0.3,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    // Fallback to default icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            showBorder
                ? Border.all(color: effectiveBorderColor, width: borderWidth)
                : null,
        color: Colors.grey[300],
      ),
      child: Icon(Icons.person, size: size * 0.5, color: Colors.grey[600]),
    );
  }
}
