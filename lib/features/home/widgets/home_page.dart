import 'dart:async';
import 'package:flutter/material.dart';

import '../Data/home_data.dart';
import '../widgets/home_scaffold.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  late final PageController _bannerCtrl;
  int _bannerIndex = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerCtrl = PageController();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bannerCtrl.hasClients) return;
      final next = (_bannerIndex + 1) % HomeData.banners.length;
      _bannerCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      selectedIndex: _selectedIndex,
      onChangeTab: (i) => setState(() => _selectedIndex = i),
      bannerCtrl: _bannerCtrl,
      bannerIndex: _bannerIndex,
      onBannerChanged: (i) => setState(() => _bannerIndex = i),
    );
  }
}
