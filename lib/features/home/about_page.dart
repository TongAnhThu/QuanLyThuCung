import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu dịch vụ'),
        backgroundColor: const Color(0xFF1E90FF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Pet Shop - Chăm sóc và đồng hành',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Text(
              '• Đặt lịch tắm, spa, grooming cho chó mèo với giá minh bạch.\n'
              '• Mua phụ kiện, thức ăn và đồ chơi chính hãng.\n'
              '• Lưu lịch sử mua hàng và đặt dịch vụ để bạn theo dõi dễ dàng.\n'
              '• Đội ngũ chăm sóc thú cưng tận tâm, hỗ trợ nhanh chóng.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Liên hệ hỗ trợ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('Hotline: 0123 456 789'),
            Text('Email: support@petshop.vn'),
          ],
        ),
      ),
    );
  }
}
