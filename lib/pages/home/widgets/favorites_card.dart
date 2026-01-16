import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/pages/contact_details_page.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({super.key, required this.contact});
  final FavoriteContact contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ContactDetailsPage(contact.contactDetails),
        ),
      ),
      child: SizedBox(
        width: 170,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        // color: priorityMap(contact.priority),
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 33,
                      backgroundImage: contact.contactDetails.photo != null
                          ? MemoryImage(contact.contactDetails.photo!)
                          : CachedNetworkImageProvider(
                              AppConstants.placeHolderProfileImage,
                            ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 16,
                  //     height: 16,
                  //     decoration: BoxDecoration(
                  //       color: Colors.greenAccent,
                  //       shape: BoxShape.circle,
                  //       border: Border.all(
                  //         color: const Color(0xFF1C2029),
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                contact.contactDetails.displayName.firstName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Last called: ${contact.lastCalledAt}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    // Call action
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: const Color(0xFF2D8CFF),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  child: Text(
                    'Call now',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
