import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/presentation/pages/chat_screen.dart';
import 'package:vivapro/pages/navigation/contacts_page.dart';
import 'package:vivapro/pages/navigation/recents_page.dart';
import 'package:vivapro/pages/navigation/widgets/custom_navigation_bar.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: GlobalColors.appBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: <Widget>[
                  const RecentsPage(), // 0: Heart/Home
                  const Center(child: Text("Calendar - Coming Soon")), // 1: Calendar
                  const Center(child: Text("Quick Actions")), // 2: Add
                  const ChatScreen(), // 3: Chat
                  const ContactsPage(), // 4: Profile
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavigationBar(
                selectedIndex: selectedIndex,
                onItemSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  pageController.jumpToPage(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
