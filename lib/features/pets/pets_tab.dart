import 'package:flutter/material.dart';
import '../../../theme/home_colors.dart';

class PetsTab extends StatefulWidget {
  const PetsTab({super.key});

  @override
  State<PetsTab> createState() => _PetsTabState();
}

class _PetsTabState extends State<PetsTab> {
  String _selectedPetType = 'dog';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, String>> _dogPets = [
    {
      'name': 'Border Collie',
      'age': '2 tháng',
      'price': '7.000.000 đ',
      'image': 'assets/images/11.jpg',
    },
    {
      'name': 'Border Collie',
      'age': '3 tháng',
      'price': '7.500.000 đ',
      'image': 'assets/images/21.jpg',
    },
    {
      'name': 'Phốc Sóc',
      'age': '2 tháng',
      'price': '8.000.000 đ',
      'image': 'assets/images/12.jpg',
    },
    {
      'name': 'Phốc Sóc',
      'age': '3 tháng',
      'price': '8.500.000 đ',
      'image': 'assets/images/22.jpeg',
    },
  ];

  final List<Map<String, String>> _catPets = [
    {
      'name': 'Mèo Anh lông ngắn',
      'age': '2 tháng',
      'price': '3.500.000 đ',
      'image': 'assets/images/meosco1.jpg',
    },
    {
      'name': 'Mèo Anh lông ngắn',
      'age': '3 tháng',
      'price': '3.800.000 đ',
      'image': 'assets/images/meosco2.jpg',
    },
    {
      'name': 'Mèo Anh lông ngắn',
      'age': '4 tháng',
      'price': '4.200.000 đ',
      'image': 'assets/images/meotaicup1.jpg',
    },
    {
      'name': 'Mèo Anh lông ngắn',
      'age': '5 tháng',
      'price': '4.800.000 đ',
      'image': 'assets/images/meosco2.jpg',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pets = _selectedPetType == 'dog' ? _dogPets : _catPets;

    return Column(
      children: [
        // Banner Image
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.all(12),
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
                Image.asset(
                  'assets/images/banner1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 70,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
                Container(color: Colors.black.withOpacity(0.25)),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Shop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Thú cưng yêu thương',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm thú cưng...',
              prefixIcon: const Icon(
                Icons.search,
                color: HomeColors.primaryDark,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: HomeColors.primaryDark,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Card filter + list
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPetFilterButton('dog', Icons.pets, 'Chó'),
                    const SizedBox(width: 16),
                    _buildPetFilterButton('cat', Icons.flutter_dash, 'Mèo'),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return _buildPetCard(pet);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetFilterButton(String type, IconData icon, String label) {
    final isSelected = _selectedPetType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedPetType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? HomeColors.primaryDark : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HomeColors.primaryDark.withOpacity(0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Map<String, String> pet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () =>
            Navigator.pushNamed(context, '/pet-detail', arguments: pet),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: HomeColors.softBg,
                  child: Image.asset(
                    pet['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return const Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tuổi: ${pet['age'] ?? ''}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet['price'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: HomeColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
