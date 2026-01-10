// TODO Implement this library.
import 'package:flutter/material.dart';

import '../data/home_data.dart';
import '../widgets/home_section.dart';

class HomeContent extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerIndex;
  final ValueChanged<int> onBannerChanged;
  final ValueChanged<int> onChangeTabIndex;

  const HomeContent({
    super.key,
    required this.bannerCtrl,
    required this.bannerIndex,
    required this.onBannerChanged,
    required this.onChangeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== HERO BANNER 4 ẢNH AUTO SLIDE ======
          Container(
            height: screenHeight * 0.32,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: bannerCtrl,
                    itemCount: HomeData.banners.length,
                    onPageChanged: onBannerChanged,
                    itemBuilder: (_, i) =>
                        Image.asset(HomeData.banners[i], fit: BoxFit.cover),
                  ),

                  // Dots
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(HomeData.banners.length, (i) {
                        final active = i == bannerIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: active ? 16 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: active
                                ? Colors.white
                                : Colors.white70.withOpacity(0.6),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSection(
                  title: 'Thú cưng nổi bật',
                  items: HomeData.homePets,
                  icon: Icons.pets,
                  onViewMore: () => onChangeTabIndex(1),
                ),
                const SizedBox(height: 18),
                HomeSection(
                  title: 'Vật phẩm',
                  items: HomeData.homeItems,
                  icon: Icons.inventory_2_outlined,
                  onViewMore: () => onChangeTabIndex(3),
                ),
                const SizedBox(height: 18),
                HomeSection(
                  title: 'Dịch vụ',
                  items: HomeData.homeServices,
                  icon: Icons.spa_outlined,
                  onViewMore: () => onChangeTabIndex(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
