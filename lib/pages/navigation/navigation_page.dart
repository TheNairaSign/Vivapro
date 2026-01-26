import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/providers/navigation_provider.dart';
import 'package:vivapro/pages/statistics/relationship_stats_page.dart';
import 'package:vivapro/pages/home/home_page.dart';
import 'package:vivapro/pages/navigation/profile_page.dart';
import 'package:vivapro/pages/navigation/recents_page.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/pages/navigation/widgets/bottom_nav_bar.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(navigationIndexProvider);
    pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    // Listen to index changes to animate the PageView
    ref.listen<int>(navigationIndexProvider, (previous, next) {
      if (pageController.hasClients && pageController.page?.round() != next) {
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });


    List<Widget> pages = [
      HomePage(),
      const RecentsPage(),
      const RelationshipStatsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (int index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactPickerPage(),
            ),
          );
          if (contact != null && context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleCallPage(contact: contact),
              ),
            );
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

