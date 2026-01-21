import 'package:flutter/material.dart';
import 'package:vivapro/pages/statistics/relationship_stats_page.dart';
import 'package:vivapro/pages/home/home_page.dart';
import 'package:vivapro/pages/navigation/profile_page.dart';
import 'package:vivapro/pages/navigation/recents_page.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/pages/navigation/widgets/bottom_nav_bar.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
      HomePage(),
      const RecentsPage(),
const RelationshipStatsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: pages.elementAt(selectedIndex),
      bottomNavigationBar:  BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (int index) async {
          setState(() {
            selectedIndex = index;
          });
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
        // shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

/*
  void _handlePlusButtonAction() async {
    switch (selectedIndex) {
      case 0:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Home Action")));
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFavoritePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewChatScreen()),
        );
        break;
      case 4:
        try {
          await FlutterContacts.openExternalInsert();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to open contacts: $e")),
            );
          }
        }
        break;
    }
  }
  */
}
