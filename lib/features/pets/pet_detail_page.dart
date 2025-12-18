import 'package:flutter/material.dart';

import '../cart/cart_service.dart';
import '../cart/cart_page.dart';

class PetDetailPage extends StatelessWidget {
  static const String routeName = '/pet-detail';
  final Map<String, String> pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ===== NỬA TRÊN: ẢNH THÚ CƯNG =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1AD0BE).withOpacity(0.3),
                    const Color(0xFF0D8F87).withOpacity(0.3),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.pets,
                  size: 120,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),

          // ===== NỬA DƯỚI: THÔNG TIN =====
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.only(
                top: 80,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mô tả về ${pet['name']}. Đây là một thú cưng tuyệt vời, khỏe mạnh và thân thiện.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),

                  // ===== 2 BUTTON: GIỎ HÀNG + MUA NGAY =====
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            CartService.instance.addPet(pet);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã thêm vào giỏ hàng'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: const Text('Thêm giỏ hàng'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: const Color(0xFF0D8F87),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            CartService.instance.addPet(pet);
                            Navigator.pushNamed(context, CartPage.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D8F87),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Mua ngay'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ===== CARD THÔNG TIN TRÊN RANH GIỚI =====
          Positioned(
            top: screenHeight * 0.5 - 60,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Row 1: Tên (trái) | Giới tính (phải)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pet['price'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D8F87),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.male,
                                size: 18,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Đực',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 2: Giống loài (trái) | Tuổi (phải)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoChip(Icons.category_outlined, 'Giống chó'),
                        _buildInfoChip(Icons.cake_outlined, pet['age'] ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== NÚT QUAY LẠI GÓC TRÁI TRÊN =====
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0D8F87)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
