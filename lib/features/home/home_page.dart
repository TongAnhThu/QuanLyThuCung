import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Trang chủ

  final List<Map<String, String>> _homePets = const [
    {
      'name': 'Husky',
      'subtitle': '2 tháng • 7.000.000 đ',
    },
    {
      'name': 'Corgi',
      'subtitle': '3 tháng • 8.000.000 đ',
    },
    {
      'name': 'Mèo Anh',
      'subtitle': '2 tháng • 3.500.000 đ',
    },
  ];

  final List<Map<String, String>> _homeItems = const [
    {
      'name': 'Hạt Royal Canin',
      'subtitle': 'Bao 2kg • 420.000 đ',
    },
    {
      'name': 'Dây dắt da mềm',
      'subtitle': 'Mới • 180.000 đ',
    },
    {
      'name': 'Đồ chơi gặm',
      'subtitle': 'Set 3 món • 95.000 đ',
    },
  ];

  final List<Map<String, String>> _homeServices = const [
    {
      'name': 'Spa & tắm',
      'subtitle': 'Từ 180.000 đ',
    },
    {
      'name': 'Khách sạn thú cưng',
      'subtitle': '250.000 đ/đêm',
    },
    {
      'name': 'Tỉa lông',
      'subtitle': 'Từ 150.000 đ',
    },
  ];

  final List<Map<String, String>> _posts = const [
    {
      'title': 'Top 5 sự thật về chó',
      'content': 'Chó có khứu giác mạnh gấp 10.000 lần con người và có thể nhớ tới 250 mùi khác nhau. Ngoài ra, chó có khả năng nghe âm thanh ở tần số cao hơn con người rất nhiều, giúp chúng phát hiện nguy hiểm từ xa. Các nghiên cứu cho thấy chó có thể hiểu được hơn 150 từ ngữ và cử chỉ của con người. Chúng cũng có khả năng cảm nhận cảm xúc của chủ nhân qua giọng nói và ngôn ngữ cơ thể. Đặc biệt, chó có thể giúp giảm stress và cải thiện sức khỏe tinh thần của con người qua sự đồng hành hàng ngày.',
      'source': 'cre: Nguyễn Duy Phúc',
    },
    {
      'title': 'Các thức ăn cực độc cho mèo',
      'content': 'Sô cô la, hành tỏi, nho và sữa bò có thể gây ngộ độc hoặc rối loạn tiêu hóa nghiêm trọng cho mèo. Sô cô la chứa theobromine - chất độc với mèo, có thể gây co giật và suy tim. Hành tỏi phá hủy hồng cầu, dẫn đến thiếu máu. Nho và nho khô có thể gây suy thận cấp tính. Sữa bò khiến nhiều mèo trưởng thành bị tiêu chảy do thiếu enzyme lactase. Ngoài ra, cần tránh cho mèo ăn xương gà (dễ vỡ và đâm thủng ruột), cà phê, rượu, bột nở, và các loại hạt macadamia. Luôn kiểm tra thành phần thức ăn trước khi cho mèo ăn.',
      'source': 'cre: Minh Anh',
    },
    {
      'title': 'Lưu ý khi tắm cho chó',
      'content': 'Chỉ tắm bằng nước ấm, tránh nước vào tai; dùng sữa tắm dành riêng cho thú cưng để không kích ứng da. Trước khi tắm, hãy chải lông kỹ để loại bỏ lông rụng và rối. Kiểm tra nhiệt độ nước bằng cổ tay để đảm bảo không quá nóng hay lạnh. Thoa sữa tắm nhẹ nhàng theo chiều mọc lông, tránh vùng mắt và tai. Xả sạch hoàn toàn để không còn bọt xà phòng gây ngứa da. Sau tắm, dùng khăn lau khô và sấy ở nhiệt độ vừa phải, giữ khoảng cách an toàn. Tần suất tắm nên 2-4 tuần/lần tùy giống chó và mức độ bẩn.',
      'source': 'cre: Thảo My',
    },
    {
      'title': 'Cách chọn thức ăn hạt',
      'content': 'Ưu tiên hạt có đạm động vật cao, không chất tạo màu, và phù hợp độ tuổi/giống của thú cưng. Đọc kỹ thành phần trên bao bì: nguồn đạm tốt như thịt gà, thịt bò, cá nên nằm trong top 3 thành phần đầu tiên. Tránh hạt có quá nhiều ngũ cốc rẻ tiền như ngô, lúa mì làm chất độn. Kiểm tra hạn sử dụng và bảo quản đúng cách trong hộp kín, nơi khô ráo. Với chó con, chọn hạt puppy giàu năng lượng; chó trưởng thành cần công thức cân bằng; chó già nên dùng hạt ít calo, bổ sung khớp. Quan sát phản ứng của thú cưng: nếu bị tiêu chảy, rụng lông hay ngứa da, có thể do dị ứng - cần đổi loại hạt khác.',
      'source': 'cre: Gia Bảo',
    },
    {
      'title': 'Dấu hiệu mèo bị stress',
      'content': 'Mèo trốn kỹ, bỏ ăn, liếm lông quá mức; hãy tạo góc trú an toàn và chơi nhẹ nhàng mỗi ngày. Stress ở mèo có thể biểu hiện qua hành vi hung hăng đột ngột, tiểu bậy ngoài khay vệ sinh, hoặc kêu rên liên tục. Nguyên nhân thường do thay đổi môi trường (chuyển nhà, khách lạ), ồn ào kéo dài, hoặc xung đột với thú cưng khác. Để giảm stress, cung cấp nhiều nơi trú ẩn yên tĩnh ở độ cao khác nhau, sử dụng pheromone xoa dịu, duy trì lịch trình cho ăn đều đặn. Chơi đùa đều đặn với đồ chơi kích thích bản năng săn mồi cũng giúp giải tỏa căng thẳng hiệu quả.',
      'source': 'cre: Khánh Vy',
    },
  ];

  final List<_TabItem> _tabs = const [
    _TabItem(
      label: 'Bài viết',
      icon: Icons.article_outlined,
      description: 'Các bài viết về chăm sóc thú cưng',
    ),
    _TabItem(
      label: 'Thú cưng',
      icon: Icons.pets,
      description: 'Danh sách thú cưng đang bán',
    ),
    _TabItem(label: 'Trang chủ', icon: Icons.home, description: 'Trang chủ'),
    _TabItem(
      label: 'Vật phẩm',
      icon: Icons.inventory_2_outlined,
      description: 'Thức ăn, đồ chơi, quần áo và phụ kiện',
    ),
    _TabItem(
      label: 'Dịch vụ',
      icon: Icons.spa_outlined,
      description: 'Tắm, spa, khách sạn thú cưng, chăm sóc khác',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_selectedIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),

      // 🔽 BOTTOM NAV ĐÃ CHỈNH
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _tabs.length,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.none,
        backgroundColor: Colors.white,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        splashSpeedInMilliseconds: 300,
        splashRadius: 40,
        height: 70,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _selectedIndex = index),

        tabBuilder: (index, isActive) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 👇 HIỆU ỨNG "LÚN XUỐNG" Ở NỀN
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: isActive ? 46 : 0,
                height: isActive ? 10 : 0,
                margin: const EdgeInsets.only(top: 34),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, -2),
                            blurRadius: 6,
                          ),
                        ]
                      : [],
                ),
              ),

              // 👇 ICON HÌNH TRÒN
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isActive ? 1.15 : 1.0,
                child: Material(
                  color: isActive
                      ? const Color(0xFF0D8F87)
                      : Colors.transparent,
                  shape: const CircleBorder(),
                  elevation: isActive ? 8 : 0,
                  shadowColor: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _tabs[index].icon,
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

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return _buildPostsTab();
    }
    // Trang "Thú cưng" (index 1)
    if (_selectedIndex == 1) {
      return const _PetsTab();
    }

    // Trang chủ (index 2)
    if (_selectedIndex == 2) {
      return _buildHomeContent();
    }

    // Trang vật phẩm (index 3)
    if (_selectedIndex == 3) {
      return const _ItemsTab();
    }

    // Trang dịch vụ (index 4)
    if (_selectedIndex == 4) {
      return const _ServicesTab();
    }

    final tab = _tabs[_selectedIndex];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tab.label,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            tab.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Nội dung ${tab.label} sẽ hiển thị ở đây',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, String> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'] ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post['content'] ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post['source'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/post-detail', arguments: post);
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.32,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1AD0BE), Color(0xFF0D8F87)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                  Icon(
                    Icons.pets,
                    size: 120,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Chào mừng đến Pet Shop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Khám phá thú cưng, đồ dùng và dịch vụ chỉ với vài chạm.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                _buildSection('Thú cưng nổi bật', _homePets, Icons.pets, 1),
                const SizedBox(height: 18),
                _buildSection('Vật phẩm', _homeItems, Icons.inventory_2_outlined, 3),
                const SizedBox(height: 18),
                _buildSection('Dịch vụ', _homeServices, Icons.spa_outlined, 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<Map<String, String>> items,
    IconData icon,
    int targetIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedIndex = targetIndex),
              child: const Text('Xem thêm'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildHomeCard(item, icon);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHomeCard(Map<String, String> item, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFEFF9F8),
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFF0D8F87), size: 40),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item['name'] ?? '',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            item['subtitle'] ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1AD0BE), Color(0xFF0D8F87)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user_avatar.png',
                  fit: BoxFit.cover,
                  width: 68,
                  height: 68,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.pets,
                    size: 36,
                    color: Color(0xFF0D8F87),
                  ),
                ),
              ),
            ),
            accountName: const Text('Pet Lover'),
            accountEmail: const Text('petshop@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Thông tin người dùng'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đi tới thông tin người dùng')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About us'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pet Shop - about us')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final String description;
  const _TabItem({
    required this.label,
    required this.icon,
    required this.description,
  });
}

// ===== TRANG THÚ CƯNG =====
class _PetsTab extends StatefulWidget {
  const _PetsTab();

  @override
  State<_PetsTab> createState() => _PetsTabState();
}

class _PetsTabState extends State<_PetsTab> {
  String _selectedPetType = 'dog'; // 'dog' or 'cat'
  final TextEditingController _searchCtrl = TextEditingController();

  // Dữ liệu mẫu
  final List<Map<String, String>> _dogPets = [
    {
      'name': 'Golden Retriever',
      'age': '3 tháng',
      'price': '5.000.000 đ',
      'image': 'dog1',
    },
    {
      'name': 'Husky',
      'age': '2 tháng',
      'price': '7.000.000 đ',
      'image': 'dog2',
    },
    {
      'name': 'Poodle',
      'age': '4 tháng',
      'price': '4.500.000 đ',
      'image': 'dog3',
    },
    {
      'name': 'Corgi',
      'age': '3 tháng',
      'price': '8.000.000 đ',
      'image': 'dog4',
    },
  ];

  final List<Map<String, String>> _catPets = [
    {
      'name': 'Mèo Anh lông ngắn',
      'age': '2 tháng',
      'price': '3.500.000 đ',
      'image': 'cat1',
    },
    {
      'name': 'Mèo Ba Tư',
      'age': '3 tháng',
      'price': '6.000.000 đ',
      'image': 'cat2',
    },
    {
      'name': 'Mèo Xiêm',
      'age': '4 tháng',
      'price': '2.800.000 đ',
      'image': 'cat3',
    },
    {
      'name': 'Mèo Scottish Fold',
      'age': '3 tháng',
      'price': '7.500.000 đ',
      'image': 'cat4',
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
        // 1️⃣ Banner Image (1/3 chiều cao body, fixed, bo góc)
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF1AD0BE), Color(0xFF0D8F87)],
            ),
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
                // Placeholder image - thay bằng Image.asset nếu có ảnh thật
                Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
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
                              color: Colors.black.withOpacity(0.3),
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

        // 2️⃣ Thanh tìm kiếm
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm thú cưng...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0D8F87)),
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
                  color: Color(0xFF0D8F87),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // 3️⃣ Card chứa filter (Chó/Mèo) + Danh sách
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
                // 🐶🐱 Filter buttons
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

                // 📜 Danh sách thú cưng
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
          color: isSelected ? const Color(0xFF0D8F87) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0D8F87).withOpacity(0.3),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Hình bên trái
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _selectedPetType == 'dog' ? Icons.pets : Icons.flutter_dash,
                size: 40,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin bên phải
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
                    'Tuổi: ${pet['age']}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet['price'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D8F87),
                    ),
                  ),
                ],
              ),
            ),

            // Nút chi tiết
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pet-detail', arguments: pet);
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== TRANG VẬT PHẨM =====
class _ItemsTab extends StatefulWidget {
  const _ItemsTab();

  @override
  State<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<_ItemsTab> {
  String _selectedCategory = 'Đồ chơi';

  final List<String> _categories = const [
    'Đồ chơi',
    'Đồ ăn',
    'Quần áo',
    'Lồng',
    'Dây dắt',
    'Bảng tên',
  ];

  final Map<String, List<Map<String, String>>> _itemsByCategory = const {
    'Đồ chơi': [
      {'name': 'Bóng cao su', 'price': '45.000 đ'},
      {'name': 'Xương gặm TPR', 'price': '65.000 đ'},
      {'name': 'Chuột nhồi bông', 'price': '35.000 đ'},
      {'name': 'Dây kéo co', 'price': '75.000 đ'},
      {'name': 'Bóng phát âm', 'price': '55.000 đ'},
      {'name': 'Gậy laser', 'price': '80.000 đ'},
    ],
    'Đồ ăn': [
      {'name': 'Royal Canin 2kg', 'price': '420.000 đ'},
      {'name': 'Pate cho mèo', 'price': '35.000 đ'},
      {'name': 'Xương gặm sạch răng', 'price': '25.000 đ'},
      {'name': 'Snack dinh dưỡng', 'price': '48.000 đ'},
      {'name': 'Hạt Ganador 5kg', 'price': '550.000 đ'},
      {'name': 'Sữa dê tươi', 'price': '65.000 đ'},
    ],
    'Quần áo': [
      {'name': 'Áo hoodie', 'price': '120.000 đ'},
      {'name': 'Áo mưa', 'price': '85.000 đ'},
      {'name': 'Đầm công chúa', 'price': '150.000 đ'},
      {'name': 'Áo len dệt kim', 'price': '95.000 đ'},
      {'name': 'Bộ vest lịch sự', 'price': '180.000 đ'},
      {'name': 'Áo thun cotton', 'price': '60.000 đ'},
    ],
    'Lồng': [
      {'name': 'Lồng sắt 60cm', 'price': '450.000 đ'},
      {'name': 'Lồng gấp gọn', 'price': '380.000 đ'},
      {'name': 'Nhà gỗ ngoài trời', 'price': '850.000 đ'},
      {'name': 'Lồng mèo 3 tầng', 'price': '1.200.000 đ'},
      {'name': 'Túi vận chuyển', 'price': '220.000 đ'},
      {'name': 'Balo phi hành gia', 'price': '320.000 đ'},
    ],
    'Dây dắt': [
      {'name': 'Dây da mềm 120cm', 'price': '180.000 đ'},
      {'name': 'Dây tự cuộn 5m', 'price': '250.000 đ'},
      {'name': 'Yếm đai chữ H', 'price': '95.000 đ'},
      {'name': 'Dây nylon phản quang', 'price': '75.000 đ'},
      {'name': 'Bộ dây + yếm cao cấp', 'price': '350.000 đ'},
      {'name': 'Dây xích kim loại', 'price': '120.000 đ'},
    ],
    'Bảng tên': [
      {'name': 'Tag nhôm khắc laser', 'price': '50.000 đ'},
      {'name': 'Tag hình xương inox', 'price': '65.000 đ'},
      {'name': 'Vòng cổ có tên', 'price': '120.000 đ'},
      {'name': 'QR code thông minh', 'price': '180.000 đ'},
      {'name': 'Tag hình tim mica', 'price': '45.000 đ'},
      {'name': 'Chip định vị GPS', 'price': '550.000 đ'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = _itemsByCategory[_selectedCategory] ?? [];

    return Column(
      children: [
        // Danh sách category ngang
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryChip(category);
            },
          ),
        ),

        const Divider(height: 1),

        // GridView 2 cột
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D8F87) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0D8F87).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, String> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF9F8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: Color(0xFF0D8F87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item['price'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D8F87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== TRANG DỊCH VỤ =====
class _ServicesTab extends StatefulWidget {
  const _ServicesTab();

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  String _selectedSpecies = 'dog';
  String _selectedWeight = '<5kg';

  final List<String> _weights = const ['<5kg', '<10kg', '<20kg', '>=20kg'];

  final List<Map<String, dynamic>> _combos = const [
    {
      'name': 'Gói 1',
      'items': ['Tắm', 'Sấy', 'Chải lông', 'Cắt móng'],
    },
    {
      'name': 'Gói 2',
      'items': ['Gói 1', 'Nhuộm lông'],
    },
    {
      'name': 'Gói 3',
      'items': ['Gói 1', 'Nhuộm lông', 'Dưỡng lông'],
    },
    {
      'name': 'FULL',
      'items': ['Tắm', 'Sấy', 'Chải lông', 'Cắt móng', 'Nhuộm', 'Dưỡng lông', 'Tỉa lông'],
    },
  ];

  final List<String> _singleServices = const [
    'Tắm + sấy',
    'Cắt móng',
    'Vệ sinh tai',
    'Vệ sinh mắt',
    'Dưỡng lông',
    'Nhuộm lông',
    'Tỉa lông',
    'Chải lông',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chó / Mèo selector
                Row(
                  children: [
                    Expanded(child: _buildSpeciesCard('dog', Icons.pets, 'Chó')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSpeciesCard('cat', Icons.flutter_dash, 'Mèo')),
                  ],
                ),

                const SizedBox(height: 16),

                // Cân nặng
                Text(
                  'Cân nặng',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _weights.map((w) => _buildWeightCard(w)).toList(),
                ),

                const SizedBox(height: 20),

                // Combo dịch vụ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Combo dịch vụ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Kéo ngang để xem', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _combos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final combo = _combos[index];
                      return _buildComboCard(combo);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Dịch vụ lẻ
                const Text('Dịch vụ lẻ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Column(
                  children: _singleServices.map(_buildSingleServiceItem).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesCard(String species, IconData icon, String label) {
    final isSelected = _selectedSpecies == species;
    return GestureDetector(
      onTap: () => setState(() => _selectedSpecies = species),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isSelected ? 4 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 28, color: isSelected ? const Color(0xFF0D8F87) : Colors.grey[700]),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? const Color(0xFF0D8F87) : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightCard(String label) {
    final isSelected = _selectedWeight == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedWeight = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D8F87) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0D8F87).withOpacity(0.35)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0D8F87).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fitness_center, size: 18, color: Color(0xFF0D8F87)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboCard(Map<String, dynamic> combo) {
    final List<String> items = List<String>.from(combo['items'] as List);
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spa_outlined, color: Color(0xFF0D8F87)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  combo['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items
                    .map(
                      (e) => Row(
                        children: [
                          const Icon(Icons.check, size: 16, color: Color(0xFF0D8F87)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              e,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleServiceItem(String label) {
    final priceText = _formatPrice(_priceForService(label));
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.spa_outlined, color: Color(0xFF0D8F87)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              priceText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D8F87),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  int _priceForService(String service) {
    final species = _selectedSpecies; // 'dog' or 'cat'
    final dogBase = <String, int>{
      'Tắm + sấy': 20000,
      'Cắt móng': 8000,
      'Vệ sinh tai': 7000,
      'Vệ sinh mắt': 6000,
      'Dưỡng lông': 15000,
      'Nhuộm lông': 25000,
      'Tỉa lông': 22000,
      'Chải lông': 12000,
    };
    final catBase = <String, int>{
      'Tắm + sấy': 18000,
      'Cắt móng': 8000,
      'Vệ sinh tai': 7000,
      'Vệ sinh mắt': 6000,
      'Dưỡng lông': 14000,
      'Nhuộm lông': 24000,
      'Tỉa lông': 20000,
      'Chải lông': 11000,
    };

    final base = species == 'dog' ? (dogBase[service] ?? 10000) : (catBase[service] ?? 10000);

    // Nhẹ nhàng tăng theo mốc cân nặng (cộng thêm một ít)
    final increment = _weightIncrement();
    final price = base + increment;
    return (price / 1000).round() * 1000; // làm tròn nghìn
  }

  int _weightIncrement() {
    switch (_selectedWeight) {
      case '<5kg':
        return 0;
      case '<10kg':
        return 10000; // +10k
      case '<20kg':
        return 25000; // +25k
      case '>=20kg':
        return 40000; // +40k
      default:
        return 0;
    }
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      final rem = (idx - 1) % 3;
      if (rem == 0 && i != s.length - 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }
}
