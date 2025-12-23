import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/messaging/presentation/pages/chat_screen.dart';
import 'package:vivapro/pages/Home_page.dart.dart';
import 'package:vivapro/pages/navigation/contacts_page.dart';
import 'package:vivapro/pages/navigation/recents_page.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/contacts/presentation/pages/add_favorite_page.dart';
import 'package:vivapro/messaging/presentation/pages/new_chat_screen.dart';
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
                  if (index == 2) {
                    _handlePlusButtonAction();
                  } else {
                    setState(() {
                      selectedIndex = index;
                    });
                    pageController.jumpToPage(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePlusButtonAction() async {
    switch (selectedIndex) {
      case 0:
        // HomePage Action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Home Action")),
        );
        break;
      case 1:
        // RecentsPage Action
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFavoritePage()),
        );
        break;
      case 3:
        // ChatScreen Action
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewChatScreen()),
        );
        break;
      case 4:
        // ContactsPage Action
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
}
