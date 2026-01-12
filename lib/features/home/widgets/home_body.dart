import 'package:flutter/material.dart';

import '../../items/items_tab.dart';
import '../../pets/pets_tab.dart';
import 'home_content.dart';
import '../../posts/PostsTab.dart';

class HomeBody extends StatelessWidget {
  final int selectedIndex;

  final PageController bannerCtrl;
  final int bannerIndex;
  final ValueChanged<int> onBannerChanged;
  final ValueChanged<int> onChangeTabIndex;

  const HomeBody({
    super.key,
    required this.selectedIndex,
    required this.bannerCtrl,
    required this.bannerIndex,
    required this.onBannerChanged,
    required this.onChangeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 0) return const PostsTab(); // ✅ Firebase
    if (selectedIndex == 1) return const PetsTab();
    if (selectedIndex == 2) {
      return HomeContent(
        bannerCtrl: bannerCtrl,
        bannerIndex: bannerIndex,
        onBannerChanged: onBannerChanged,
        onChangeTabIndex: onChangeTabIndex,
      );
    }
    if (selectedIndex == 3) return const ItemsTab();

    return const Center(child: Text('Tab không hợp lệ'));
  }
}
