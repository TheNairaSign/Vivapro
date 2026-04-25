import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/utils/relationship_health_utils.dart';
import 'package:vivapro/core/providers/navigation_provider.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';


class RelationshipHealthContainer extends ConsumerWidget {
  const RelationshipHealthContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteCacheServiceProvider).watchFavorites();

    return StreamBuilder<List<FavoriteContact>>(
      stream: favoritesAsync,
      builder: (context, favoritesSnapshot) {
        final favorites = favoritesSnapshot.data ?? [];
        return BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
          final activities = state is ActivityLoaded
            ? state.activities
            : <ActivityLog>[];
        
            final healthPercentage = RelationshipHealthUtils.calculateHealthForPeriod(
              favorites,
              activities,
              'Daily',
            );
            final healthColor = RelationshipHealthUtils.getHealthColor(
              context,
              healthPercentage,
            );
            return GestureDetector(
              onTap: () {
                ref.read(navigationIndexProvider.notifier).state = 2;
              },

              child: Hero(
                tag: 'relationship_health',
                // transitionOnUserGestures: true,
                // createRectTween: (begin, end) {
                //   return Tween(
                //     begin: Rect.fromLTWH(begin!.left, begin.top, begin.width, begin.height),
                //     end: Rect.fromLTWH(end!.left, end.top, end.width, end.height),
                //   );
                // },
                child: Container(
                  height: 140,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: healthColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Icon(EvaIcons.peopleOutline, color: healthColor, size: 20),
                      ),
                      const Spacer(),
                      Text(
                        '$healthPercentage%',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: healthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Relationship Health',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}
