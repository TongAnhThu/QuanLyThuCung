import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  static const String routeName = '/admin';
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị hệ thống'),
        backgroundColor: const Color(0xFF1E90FF),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.pets), text: 'Thú cưng'),
            Tab(icon: Icon(Icons.inventory_2), text: 'Sản phẩm'),
            Tab(icon: Icon(Icons.category), text: 'Danh mục'),
            Tab(icon: Icon(Icons.room_service), text: 'Dịch vụ'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Đặt dịch vụ'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Lịch sử'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PetsManagement(firestore: _firestore),
          _ProductsManagement(firestore: _firestore),
          _CategoriesManagement(firestore: _firestore),
          _ServicesManagement(firestore: _firestore),
          _ServiceBookingsView(firestore: _firestore),
          _PurchaseHistoryView(firestore: _firestore),
        ],
      ),
    );
  }
}

// ========== Quản lý Thú cưng ==========
class _PetsManagement extends StatelessWidget {
  final FirebaseFirestore firestore;
  const _PetsManagement({required this.firestore});

  String _formatPetPrice(dynamic price) {
    final priceInt = (price is int)
        ? price
        : (price is double)
        ? price.toInt()
        : int.tryParse(price?.toString() ?? '0') ?? 0;
    final text = priceInt.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      if (pos % 3 == 0 && i != 0) buf.write('.');
      buf.write(text[i]);
    }
    return '${buf.toString()} đ';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('pets').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final pets = snapshot.data?.docs ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showPetDialog(context, firestore),
                icon: const Icon(Icons.add),
                label: const Text('Thêm thú cưng mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: pets.isEmpty
                  ? const Center(child: Text('Chưa có thú cưng nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final doc = pets[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: data['image'] != null
                                      ? AssetImage(data['image'])
                                      : null,
                                  child: data['image'] == null
                                      ? const Icon(Icons.pets)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatPetPrice(data['price']),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'Tuổi: ${data['age'] ?? 'N/A'}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showPetDialog(
                                    context,
                                    firestore,
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _deletePet(context, firestore, doc.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  static void _showPetDialog(
    BuildContext context,
    FirebaseFirestore firestore, {
    String? docId,
    Map<String, dynamic>? data,
  }) {
    final nameCtrl = TextEditingController(text: data?['name']);
    final priceCtrl = TextEditingController(
      text: data?['price']?.toString() ?? '',
    );
    final ageCtrl = TextEditingController(text: data?['age']?.toString() ?? '');
    final imageCtrl = TextEditingController(text: data?['image']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Thêm thú cưng' : 'Sửa thú cưng'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên thú cưng'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Giá (số nguyên)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ageCtrl,
                decoration: const InputDecoration(labelText: 'Tuổi'),
              ),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Đường dẫn ảnh'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final price = int.tryParse(priceCtrl.text) ?? 0;
              final petData = {
                'name': nameCtrl.text,
                'price': price,
                'age': ageCtrl.text,
                'image': imageCtrl.text,
              };

              if (docId == null) {
                await firestore.collection('pets').add(petData);
              } else {
                await firestore.collection('pets').doc(docId).update(petData);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    docId == null ? 'Đã thêm thú cưng' : 'Đã cập nhật thú cưng',
                  ),
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  static void _deletePet(
    BuildContext context,
    FirebaseFirestore firestore,
    String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa thú cưng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await firestore.collection('pets').doc(docId).delete();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa thú cưng')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// ========== Quản lý Sản phẩm ==========
class _ProductsManagement extends StatelessWidget {
  final FirebaseFirestore firestore;
  const _ProductsManagement({required this.firestore});

  String _formatProductPrice(dynamic price) {
    final priceInt = (price is int)
        ? price
        : (price is double)
        ? price.toInt()
        : int.tryParse(price?.toString() ?? '0') ?? 0;
    final text = priceInt.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      buf.write(text[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '$buf đ';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data?.docs ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showProductDialog(context, firestore),
                icon: const Icon(Icons.add),
                label: const Text('Thêm sản phẩm mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('Chưa có sản phẩm nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final doc = products[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: data['image'] != null
                                      ? AssetImage(data['image'])
                                      : null,
                                  child: data['image'] == null
                                      ? const Icon(Icons.inventory_2)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatProductPrice(data['price']),
                                        style: const TextStyle(
                                          color: Color(0xFF1E90FF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        data['category'] ?? 'Chưa phân loại',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showProductDialog(
                                    context,
                                    firestore,
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteProduct(
                                    context,
                                    firestore,
                                    doc.id,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  static void _showProductDialog(
    BuildContext context,
    FirebaseFirestore firestore, {
    String? docId,
    Map<String, dynamic>? data,
  }) {
    final nameCtrl = TextEditingController(text: data?['name']);
    final priceCtrl = TextEditingController(
      text: data?['price']?.toString() ?? '',
    );
    final categoryCtrl = TextEditingController(text: data?['category']);
    final descCtrl = TextEditingController(text: data?['moTa']);
    final imageCtrl = TextEditingController(text: data?['image']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Danh mục'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Giá (số nguyên)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Đường dẫn ảnh'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final price = int.tryParse(priceCtrl.text) ?? 0;
              final productData = {
                'name': nameCtrl.text,
                'category': categoryCtrl.text,
                'price': price,
                'moTa': descCtrl.text,
                'image': imageCtrl.text,
              };

              if (docId == null) {
                await firestore.collection('products').add(productData);
              } else {
                await firestore
                    .collection('products')
                    .doc(docId)
                    .update(productData);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    docId == null ? 'Đã thêm sản phẩm' : 'Đã cập nhật sản phẩm',
                  ),
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  static void _deleteProduct(
    BuildContext context,
    FirebaseFirestore firestore,
    String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await firestore.collection('products').doc(docId).delete();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa sản phẩm')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// ========== Quản lý Dịch vụ ==========
class _ServicesManagement extends StatelessWidget {
  final FirebaseFirestore firestore;
  const _ServicesManagement({required this.firestore});

  String _formatServicePrice(dynamic price) {
    final priceInt = (price is int)
        ? price
        : (price is double)
        ? price.toInt()
        : int.tryParse(price?.toString() ?? '0') ?? 0;
    final text = priceInt.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      buf.write(text[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '$buf đ';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final services = snapshot.data?.docs ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showServiceDialog(context, firestore),
                icon: const Icon(Icons.add),
                label: const Text('Thêm dịch vụ mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: services.isEmpty
                  ? const Center(child: Text('Chưa có dịch vụ nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final doc = services[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.room_service),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Chó: ${_formatServicePrice(data['dogBase'])}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'Mèo: ${_formatServicePrice(data['catBase'])}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showServiceDialog(
                                    context,
                                    firestore,
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteService(
                                    context,
                                    firestore,
                                    doc.id,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  static void _showServiceDialog(
    BuildContext context,
    FirebaseFirestore firestore, {
    String? docId,
    Map<String, dynamic>? data,
  }) {
    final nameCtrl = TextEditingController(text: data?['name']);
    final dogBaseCtrl = TextEditingController(
      text: data?['dogBase']?.toString() ?? '',
    );
    final catBaseCtrl = TextEditingController(
      text: data?['catBase']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Thêm dịch vụ' : 'Sửa dịch vụ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên dịch vụ'),
              ),
              TextField(
                controller: dogBaseCtrl,
                decoration: const InputDecoration(
                  labelText: 'Giá cho chó (số nguyên)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: catBaseCtrl,
                decoration: const InputDecoration(
                  labelText: 'Giá cho mèo (số nguyên)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final dogBase = int.tryParse(dogBaseCtrl.text) ?? 0;
              final catBase = int.tryParse(catBaseCtrl.text) ?? 0;
              final serviceData = {
                'name': nameCtrl.text,
                'kind': 'single',
                'dogBase': dogBase,
                'catBase': catBase,
                'isActive': true,
                'itemsRaw': [],
                'itemsResolved': [],
              };

              if (docId == null) {
                await firestore.collection('services').add(serviceData);
              } else {
                await firestore
                    .collection('services')
                    .doc(docId)
                    .update(serviceData);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    docId == null ? 'Đã thêm dịch vụ' : 'Đã cập nhật dịch vụ',
                  ),
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  static void _deleteService(
    BuildContext context,
    FirebaseFirestore firestore,
    String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa dịch vụ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await firestore.collection('services').doc(docId).delete();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa dịch vụ')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// ========== Xem lịch sử mua hàng (Admin - xem tất cả) ==========
class _PurchaseHistoryView extends StatelessWidget {
  final FirebaseFirestore firestore;
  const _PurchaseHistoryView({required this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('usercardhistory')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final purchases = snapshot.data?.docs ?? [];

        if (purchases.isEmpty) {
          return const Center(child: Text('Chưa có lịch sử mua hàng'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            final doc = purchases[index];
            final data = doc.data() as Map<String, dynamic>;
            final items =
                (data['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
            final timestamp = data['timestamp'] as Timestamp?;
            final date = timestamp?.toDate();
            final userId = data['userId'] as String? ?? 'Unknown';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFF1E90FF),
                ),
                title: Text('Đơn hàng #${doc.id.substring(0, 8)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ID: ${userId.substring(0, userId.length > 8 ? 8 : userId.length)}...',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      'Ngày: ${date != null ? "${date.day}/${date.month}/${date.year}" : "N/A"}\n'
                      'Tổng: ${_formatPrice(data['totalAmount'] ?? 0)}\n'
                      'Phương thức: ${data['paymentMethod'] ?? "N/A"}',
                    ),
                  ],
                ),
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiết đơn hàng:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['name']} x${item['quantity']}',
                                  ),
                                ),
                                Text(
                                  _formatPrice(
                                    (item['price'] ?? 0) *
                                        (item['quantity'] ?? 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatPrice(int price) {
    final text = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      buf.write(text[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '$buf đ';
  }
}

// ========== Quản lý Danh mục sản phẩm ==========
class _CategoriesManagement extends StatelessWidget {
  final FirebaseFirestore firestore;
  const _CategoriesManagement({required this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data?.docs ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(context, firestore),
                icon: const Icon(Icons.add),
                label: const Text('Thêm danh mục mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: categories.isEmpty
                  ? const Center(child: Text('Chưa có danh mục nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final doc = categories[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(
                                    int.parse(
                                      data['color']?.toString().replaceAll(
                                            '#',
                                            '0xFF',
                                          ) ??
                                          '0xFF1E90FF',
                                    ),
                                  ),
                                  child: Icon(
                                    _getIconData(
                                      data['icon']?.toString() ?? 'category',
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data['description'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showCategoryDialog(
                                    context,
                                    firestore,
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCategory(
                                    context,
                                    firestore,
                                    doc.id,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets;
      case 'fastfood':
        return Icons.fastfood;
      case 'toys':
        return Icons.toys;
      case 'medical_services':
        return Icons.medical_services;
      case 'home':
        return Icons.home;
      case 'shopping_bag':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  static void _showCategoryDialog(
    BuildContext context,
    FirebaseFirestore firestore, {
    String? docId,
    Map<String, dynamic>? data,
  }) {
    final nameCtrl = TextEditingController(text: data?['name']);
    final descCtrl = TextEditingController(text: data?['description']);
    String selectedIcon = data?['icon']?.toString() ?? 'category';
    String selectedColor = data?['color']?.toString() ?? '#1E90FF';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(docId == null ? 'Thêm danh mục' : 'Sửa danh mục'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên danh mục'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chọn icon:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildIconButton(
                      'category',
                      Icons.category,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'pets',
                      Icons.pets,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'fastfood',
                      Icons.fastfood,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'toys',
                      Icons.toys,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'medical_services',
                      Icons.medical_services,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'home',
                      Icons.home,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                    _buildIconButton(
                      'shopping_bag',
                      Icons.shopping_bag,
                      selectedIcon,
                      (icon) => setState(() => selectedIcon = icon),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chọn màu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorButton(
                      '#1E90FF',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#FF6B6B',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#4ECDC4',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#FFD93D',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#95E1D3',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#F38181',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                    _buildColorButton(
                      '#AA96DA',
                      selectedColor,
                      (color) => setState(() => selectedColor = color),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final categoryData = {
                  'name': nameCtrl.text,
                  'description': descCtrl.text,
                  'icon': selectedIcon,
                  'color': selectedColor,
                  'createdAt': FieldValue.serverTimestamp(),
                };

                if (docId == null) {
                  await firestore.collection('categories').add(categoryData);
                } else {
                  await firestore
                      .collection('categories')
                      .doc(docId)
                      .update(categoryData);
                }

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      docId == null
                          ? 'Đã thêm danh mục'
                          : 'Đã cập nhật danh mục',
                    ),
                  ),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildIconButton(
    String iconName,
    IconData icon,
    String selectedIcon,
    Function(String) onTap,
  ) {
    final isSelected = iconName == selectedIcon;
    return InkWell(
      onTap: () => onTap(iconName),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E90FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E90FF) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[700],
          size: 28,
        ),
      ),
    );
  }

  static Widget _buildColorButton(
    String color,
    String selectedColor,
    Function(String) onTap,
  ) {
    final isSelected = color == selectedColor;
    return InkWell(
      onTap: () => onTap(color),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(int.parse(color.replaceAll('#', '0xFF'))),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  static void _deleteCategory(
    BuildContext context,
    FirebaseFirestore firestore,
    String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa danh mục này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await firestore.collection('categories').doc(docId).delete();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa danh mục')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// Xem lịch đặt dịch vụ
class _ServiceBookingsView extends StatelessWidget {
  final FirebaseFirestore firestore;

  const _ServiceBookingsView({required this.firestore});

  String _formatPrice(int price) {
    final text = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      if (pos % 3 == 0 && i != 0) buf.write(',');
      buf.write(text[i]);
    }
    return '${buf.toString()} đ';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('service_bookings')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final bookings = snapshot.data?.docs ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Chưa có lịch đặt dịch vụ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final data = booking.data() as Map<String, dynamic>;
            final bookingDate = (data['date'] as Timestamp?)?.toDate();
            final serviceName = data['serviceTitle'] ?? 'N/A';
            final userName = data['customerName'] ?? 'N/A';
            final userEmail = data['userEmail'] ?? 'N/A';
            final petType = data['petName'] ?? 'N/A';
            final price = data['price'] as int? ?? 0;
            final status = data['status'] ?? 'Chờ xác nhận';
            final notes = data['notes'] ?? '';

            final statusColor = status == 'Hoàn thành'
                ? Colors.green
                : status == 'Đã hủy'
                ? Colors.red
                : Colors.orange;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serviceName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$userName ($userEmail)',
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.pets, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Thú cưng: $petType',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          bookingDate != null
                              ? '${bookingDate.day}/${bookingDate.month}/${bookingDate.year} ${bookingDate.hour}:${bookingDate.minute.toString().padLeft(2, '0')}'
                              : 'N/A',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatPrice(price),
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ghi chú:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notes,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (status != 'Hoàn thành' && status != 'Đã hủy')
                          OutlinedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Hoàn thành'),
                            onPressed: () async {
                              await firestore
                                  .collection('service_bookings')
                                  .doc(booking.id)
                                  .update({'status': 'Hoàn thành'});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã cập nhật trạng thái'),
                                ),
                              );
                            },
                          ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: const Text('Hủy'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () async {
                            await firestore
                                .collection('service_bookings')
                                .doc(booking.id)
                                .update({'status': 'Đã hủy'});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã hủy lịch đặt')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
