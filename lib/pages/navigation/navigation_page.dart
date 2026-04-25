import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';
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


    List<Widget> pages = const [
      HomePage(),
      RecentsPage(),
      RelationshipStatsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => ref.read(navigationIndexProvider.notifier).state = index,
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
          // Check contacts permission before proceeding
          var status = await Permission.contacts.status;
          
          if (status.isPermanentlyDenied) {
            if (context.mounted) { 
              showFlushbarCustom(
                context, 
                'Permission Required', 
                'You have permanently denied contact access. Please enable it in Settings.',
                color: Colors.orange,
                mainButton: TextButton(  
                  onPressed: () => openAppSettings(),
                  child: Text('Settings', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                ),
              );
            }
            return;
          }

          if (!status.isGranted) {
            status = await Permission.contacts.request();
          }
          
          if (!status.isGranted) {
            if (context.mounted) {
              showFlushbarCustom(
                context, 
                'Permission Denied', 
                'Vivapro needs contact access to schedule calls correctly.',
                color: Colors.orange,
              );
            }
            return;
          }

          if (context.mounted) {
            final contact = await Navigator.push(context, MaterialPageRoute( builder: (context) => const ContactPickerPage()));
            if (contact != null && context.mounted) {
              Navigator.push(context, MaterialPageRoute( builder: (context) => ScheduleCallPage(contact: contact)));
            }
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

