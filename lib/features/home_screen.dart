import 'package:dreamhome_architect/features/Profile/profile_screen.dart';
import 'package:dreamhome_architect/features/home_plan/add_edit_homeplan.dart';
import 'package:dreamhome_architect/features/home_plan/view_home_plan.dart';
import 'package:dreamhome_architect/features/signin/signin_screen.dart';
import 'package:dreamhome_architect/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ViewHomeplan(),
    // AcquiredScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 200,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null ||
          currentUser.appMetadata['role'] != 'architect') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SigninScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _selectedIndex == 0 ? 'Home Architect' : 'Profile',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _pages[_selectedIndex],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: _selectedIndex == 0
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: 30, left: _selectedIndex == 0 ? 30 : 0),
                child: Material(
                  color: Colors.black.withAlpha(200),
                  borderRadius: BorderRadius.circular(64),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: GNav(
                      rippleColor: Colors.grey[800]!,
                      hoverColor: Colors.grey[700]!,
                      haptic: true,
                      tabBorderRadius: 25,
                      tabActiveBorder:
                          Border.all(color: onprimaryColor, width: 1),
                      tabBorder: Border.all(color: Colors.grey, width: 1),
                      tabShadow: [
                        BoxShadow(
                            color: Colors.grey.withAlpha(5), blurRadius: 8)
                      ],
                      curve: Curves.easeOutExpo,
                      duration: const Duration(milliseconds: 200),
                      gap: 8,
                      color: Colors.grey,
                      activeColor: Colors.white,
                      iconSize: 24,
                      tabBackgroundColor: Colors.black.withAlpha(0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      tabs: const [
                        GButton(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          icon: LineIcons.home,
                          text: 'Home',
                        ),
                        // GButton(
                        //   padding: EdgeInsets.all(10),
                        //   margin: EdgeInsets.all(5),
                        //   icon: Icons.sell_outlined,
                        //   text: 'Acquired',
                        // ),
                        GButton(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          icon: LineIcons.user,
                          text: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.black.withAlpha(200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditHomeplan(),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
