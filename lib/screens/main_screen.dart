import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: IndexedStack(
              index: _currentIndex,
              children: [
                HomeScreen(onNavigate: _changeTab),
                DiscoverScreen(onNavigate: _changeTab),
                ChatScreen(onNavigate: _changeTab),
                ProfileScreen(onNavigate: _changeTab),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.textSecondary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppTheme.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppTheme.vibrantPink,
            unselectedItemColor: AppTheme.textSecondary.withOpacity(0.5),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: '信号站',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: '共鸣场',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded),
                label: 'AI对话',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
