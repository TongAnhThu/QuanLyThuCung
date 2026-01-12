import 'package:flutter/material.dart';
import '../models/tab_item.dart';

class HomeData {
  
  static const List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];


  static const List<TabItem> tabs = [
    TabItem(
      label: 'Bài viết',
      icon: Icons.article_outlined,
      description: 'Các bài viết về chăm sóc thú cưng',
    ),
    TabItem(
      label: 'Thú cưng',
      icon: Icons.pets,
      description: 'Danh sách thú cưng đang bán',
    ),
    TabItem(
      label: 'Trang chủ',
      icon: Icons.home,
      description: 'Trang chủ',
    ),
    TabItem(
      label: 'Vật phẩm',
      icon: Icons.inventory_2_outlined,
      description: 'Thức ăn, đồ chơi, quần áo và phụ kiện',
    ),
    TabItem(
      label: 'Dịch vụ',
      icon: Icons.spa_outlined,
      description: 'Tắm, spa, khách sạn thú cưng, chăm sóc khác',
    ),
  ];
}
