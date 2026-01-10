import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:appshopbanthucung/theme/home_colors.dart';
import '../data/home_data.dart';
import 'app_drawer.dart';
import 'home_body.dart';

class HomeScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChangeTab;

  final PageController bannerCtrl;
  final int bannerIndex;
  final ValueChanged<int> onBannerChanged;

  const HomeScaffold({
    super.key,
    required this.selectedIndex,
    required this.onChangeTab,
    required this.bannerCtrl,
    required this.bannerIndex,
    required this.onBannerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomeData.tabs[selectedIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: HomeBody(
        selectedIndex: selectedIndex,
        bannerCtrl: bannerCtrl,
        bannerIndex: bannerIndex,
        onBannerChanged: onBannerChanged,
        onChangeTabIndex: onChangeTab,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: HomeData.tabs.length,
        activeIndex: selectedIndex,
        gapLocation: GapLocation.none,
        backgroundColor: Colors.white,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        splashSpeedInMilliseconds: 300,
        splashRadius: 40,
        height: 70,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: onChangeTab,
        tabBuilder: (index, isActive) {
          final tab = HomeData.tabs[index];
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: isActive ? 46 : 0,
                height: isActive ? 10 : 0,
                margin: const EdgeInsets.only(top: 34),
                decoration: BoxDecoration(
                  color: isActive
                      ? HomeColors.primaryDark.withOpacity(0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            offset: const Offset(0, -2),
                            blurRadius: 6,
                          ),
                        ]
                      : [],
                ),
              ),
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isActive ? 1.15 : 1.0,
                child: Material(
                  color: isActive ? HomeColors.primaryDark : Colors.transparent,
                  shape: const CircleBorder(),
                  elevation: isActive ? 8 : 0,
                  shadowColor: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      tab.icon,
                      size: 28,
                      color: isActive ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
