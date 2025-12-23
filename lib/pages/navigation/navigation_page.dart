import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/presentation/pages/chat_screen.dart';
import 'package:vivapro/pages/Home_page.dart.dart';
import 'package:vivapro/pages/navigation/contacts_page.dart';
import 'package:vivapro/pages/navigation/recents_page.dart';
import 'package:vivapro/pages/navigation/widgets/custom_navigation_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key, required this.user});
  final AuthUser user;

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
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
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
                  const HomePage(),
                  const RecentsPage(), 
                  const Center(child: Text("Quick Actions")), 
                  ChatScreen(user: widget.user), 
                  const ContactsPage(),
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
