import 'package:flutter/material.dart';

import '../data/home_data.dart';
import '../../items/items_tab.dart';
import '../../pets/pets_tab.dart';
//import '../../booking/booking_tab.dart';
import 'home_content.dart';
import 'posts_tab.dart';

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
    if (selectedIndex == 0) return PostsTab(posts: HomeData.posts);
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
    //if (selectedIndex == 4) return const ServicesTab();

    return const Center(child: Text('Tab không hợp lệ'));
  }
}
