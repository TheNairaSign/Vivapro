import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/pages/navigation/widgets/activity_list_view.dart';
import 'package:vivapro/pages/navigation/widgets/filter_pills.dart';
import 'package:vivapro/pages/navigation/widgets/manual_log_bottom_sheet.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  ActivityType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadActivities());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your relationship log',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            floating: true,
            pinned: true,
            actions: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                onPressed: () => _showManualLogDialog(context),
                icon: const Icon(Icons.add, color: Colors.white,),
                label: Text("Log", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
              ),
            ],
          ),
          // Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
            ),
          ),

          // Filter Pills
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: FilterPills(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
            ),
          ),

          ActivityListView(selectedFilter: _selectedFilter),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  void _showManualLogDialog(BuildContext context, {Contact? contact}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualLogBottomSheet(contact: contact),
    );
  }
}
