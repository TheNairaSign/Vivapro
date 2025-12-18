import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/call_log/presentation/widgets/call_log_item.dart';
import 'package:vivapro/contacts/presentation/widgets/favorite_item.dart';
import 'package:vivapro/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/contacts/data/favorite_contact.dart';

import 'package:vivapro/core/theme/global_colors.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/pages/navigation/contacts_page.dart';

class RecentsPage extends ConsumerStatefulWidget {
  const RecentsPage({super.key});

  @override
  ConsumerState<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends ConsumerState<RecentsPage> {
  late final Stream<List<FavoriteContact>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    context.read<CallLogBloc>().add(GetCallLogs());
    _favoritesStream = ref.read(favoritesRepository).watchFavorites();
  }

  Map<String, List<CallLogModel>> _groupLogsByDate(List<CallLogModel> logs) {
    final groups = <String, List<CallLogModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var log in logs) {
      final date = log.date;
      final logDay = DateTime(date.year, date.month, date.day);

      String key;
      if (logDay == today) {
        key = 'Today';
      } else if (logDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM d').format(date);
      }
      
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(log);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recents', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildFavoritesSection()),
          BlocBuilder<CallLogBloc, CallLogState>(
            builder: (context, state) {
              if (state is CallLogLoading) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(child: LoadingAnimationWidget.threeRotatingDots(color: GlobalColors.darkPurple, size: 20)),
                  ),
                );
              } else if (state is CallLogFailure) {
                return SliverToBoxAdapter(child: Center(child: Text(state.message)));
              } else if (state is CallLogSuccess) {
                final groupedLogs = _groupLogsByDate(state.callLogEntries);
                final keys = groupedLogs.keys.toList();

                if (groupedLogs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Text('No recent calls'),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final key = keys[index];
                        final logs = groupedLogs[key]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                              child: Text(
                                key,
                                style: TextStyle(
                                  color: GlobalColors.periwinkle,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: logs.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final log = entry.value;
                                  return Column(
                                    children: [
                                      CallLogItem(entry: log),
                                      if (i < logs.length - 1)
                                        Divider(
                                          height: 1,
                                          indent: 70,
                                          endIndent: 0,
                                          color: Colors.grey[100],
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: keys.length,
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
          child: Text(
            'Favorites',
            style: TextStyle(
              color: GlobalColors.charcoal.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: StreamBuilder<List<FavoriteContact>>(
            stream: _favoritesStream,
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              //   return Center(child: LoadingAnimationWidget.threeRotatingDots(color: GlobalColors.freshPink, size: 30));
              // }
              
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              final favorites = snapshot.data ?? [];
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildAddFavoriteButton();
                  }
                  
                  final favorite = favorites[index - 1];
                  return FavoriteItem(favoriteContact: favorite);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddFavoriteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ContactsPage()),
              );
            },
            borderRadius: BorderRadius.circular(28),

            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),

              ),
              child: Icon(
                Icons.add,
                color: Colors.grey[400],
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

