import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uridachi/features/post/presentation/pages/global_page.dart';
import 'package:uridachi/screen/chat_screens/chat_page.dart';
import 'package:uridachi/features/user/presentation/pages/profile/profile_page.dart';
import '../features/block_report/presentation/providers/block_report_provider.dart';
import '../features/user/presentation/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late PageController pageController;
  bool isKeyboardVisible = false;

  final List<ScrollController> _scrollControllers = List.generate(3, (_) => ScrollController());

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
    // _checkFirstTimeUser();

    Future.microtask(() {
      final blockReportProvider = Provider.of<BlockReportProvider>(context, listen: false);
      blockReportProvider.fetchBlockedUsers(context);

      // Load user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUser(context);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isKeyboardVisible = bottomInset > 0;
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      if (_scrollControllers[index].hasClients) {
        _scrollControllers[index].animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
      pageController.jumpToPage(index);
    }
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkFirstTimeUser() async {
    Future.delayed(Duration.zero, () {
      _showWelcomePopup();
    });
    // final prefs = await SharedPreferences.getInstance();
    // bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // if (isFirstTime) {
    //   Future.delayed(Duration.zero, () {
    //     _showWelcomePopup();
    //   });

    //   await prefs.setBool('isFirstTime', false);
    // }
  }

  void _showWelcomePopup() {
    PageController pageController = PageController();
    int currentPage = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: SizedBox(
                height: screenHeight * 0.001093 * 300,
                width: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (currentPage > 0)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage--;
                                });
                                pageController.animateToPage(
                                  currentPage,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Icon(Icons.arrow_left, size: 30, color: Color(0xFF582AB2)),
                            )
                          else
                            SizedBox(width: screenWidth * 0.002427 * 30),
                          Expanded(
                            child: PageView(
                              controller: pageController,
                              onPageChanged: (int page) {
                                setState(() {
                                  currentPage = page;
                                });
                              },
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Home Page information!',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.001093 * 10),
                                    const Text(
                                      'Explanation about global sns',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'We also have a chat page!',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.001093 * 10),
                                    const Text(
                                      'A lot of code going on in this page',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Finally a trending page!',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.001093 * 10),
                                    const Text(
                                      'Check out this page too!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'translation',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.001093 * 10),
                                    const Text(
                                      'Check out this page too!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'something else',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: screenHeight * 0.001093 * 10),
                                    const Text(
                                      'Check out this page too!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (currentPage < 4)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage++;
                                });
                                pageController.animateToPage(
                                  currentPage,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Icon(Icons.arrow_right, size: 30, color: Color(0xFF582AB2)),
                            )
                          else
                            SizedBox(width: screenWidth * 0.002427 * 30),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.001093 * 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 4.0),
                          width: currentPage == index ? screenWidth * 0.002427 * 8.0 : screenWidth * 0.002427 * 4.0,
                          height: currentPage == index ? screenHeight * 0.001093 * 8.0 : screenHeight * 0.001093 * 4.0,
                          decoration: BoxDecoration(
                            color: currentPage == index ? const Color(0xFF582AB2) : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                if (currentPage == 4)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Get Started!',
                      style: TextStyle(color: Color(0xFF582AB2)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final homeScreenItems = [
      GlobalPage(scrollController: _scrollControllers[0]),
      ChatPage(scrollController: _scrollControllers[1]),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: isKeyboardVisible
          ? null
          : Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.001093 * 3.0),
              child: Container(
                height: screenHeight * 0.001093 * 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/home_nav_icon.png',
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/home_nav_icon.png',
                        color: Color(0xFF582AB2),
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/chat_nav_icon.png',
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/chat_nav_icon.png',
                        color: Color(0xFF582AB2),
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/profile_nav_icon.png',
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/profile_nav_icon.png',
                        color: Color(0xFF582AB2),
                        height: screenHeight * 0.001093 * 24,
                        width: screenWidth * 0.002427 * 24,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xFF582AB2),
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                ),
              ),
            ),
    );
  }
}
