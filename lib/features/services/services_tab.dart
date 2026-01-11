import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/service_booking_sheet.dart';
import '../../models/booking_model.dart';
import '../../models/service_doc.dart';
import '../../../theme/home_colors.dart';

import 'service_widgets.dart'; // ✅ file widgets tách riêng

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key, this.userId = ''});

  /// Chưa dùng FirebaseAuth thì để rỗng hoặc truyền tạm "guest_1"
  final String userId;

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  String _selectedSpecies = 'dog'; // dog | cat
  String _selectedWeight = '<5kg';

  final List<String> _weights = const ['<5kg', '<10kg', '<20kg', '>=20kg'];

  Stream<QuerySnapshot<Map<String, dynamic>>> _servicesStream() {
    return FirebaseFirestore.instance
        .collection('services')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Future<void> _openBookingSheet({
    required String title,
    required List<String> items,
    int? price,
  }) async {
    final dichvuModel? res = await showServiceBookingSheet(
      context: context,
      primaryColor: HomeColors.primaryDark,
      serviceTitle: title,
      serviceItems: items,
      species: _selectedSpecies,
      weight: _selectedWeight,
      price: price,
      userId: widget.userId,
    );

    if (!mounted || res == null) return;

    await _saveBooking(res);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã nhận: ${res.serviceTitle} • ${res.petName} • ${_formatDate(res.date)} ${_formatTime(res.time)}',
        ),
      ),
    );
  }

  Future<void> _saveBooking(dichvuModel booking) async {
    final data = booking.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance.collection('service_bookings').add(data);
  }

  // ===== Picker bottom sheets =====

  Future<void> _pickSpecies() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SimplePickerSheet(
        title: 'Chọn loài',
        selectedValue: _selectedSpecies,
        items: const [
          PickerItem(value: 'dog', label: 'Chó', icon: Icons.pets),
          PickerItem(value: 'cat', label: 'Mèo', icon: Icons.pets),
        ],
      ),
    );

    if (!mounted) return;
    if (picked != null) setState(() => _selectedSpecies = picked);
  }

  Future<void> _pickWeight() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SimplePickerSheet(
        title: 'Chọn cân nặng',
        selectedValue: _selectedWeight,
        items: _weights
            .map(
              (w) => PickerItem(value: w, label: w, icon: Icons.fitness_center),
            )
            .toList(),
      ),
    );

    if (!mounted) return;
    if (picked != null) setState(() => _selectedWeight = picked);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _servicesStream(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text('Lỗi load services: ${snap.error}'));
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs.map(ServiceDoc.fromDoc).toList();
        if (docs.isEmpty) {
          return const Center(child: Text('Hiện chưa có dịch vụ.'));
        }

        final singles = docs.where((e) => e.kind == ServiceKind.single).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        final combos = docs.where((e) => e.kind == ServiceKind.combo).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        final singleByName = <String, ServiceDoc>{
          for (final s in singles) s.name: s,
        };

        return DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dịch vụ cho Boss',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chọn dịch vụ, xem combo gồm gì, rồi đặt lịch nhanh.',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 12),

                    // ===== Filter bar =====
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: HomeColors.primaryDark.withOpacity(0.18),
                        ),
                        color: HomeColors.primaryDark.withOpacity(0.04),
                      ),
                      child: Row(
                        children: [
                          FilterChipButton(
                            icon: Icons.pets,
                            label: _selectedSpecies == 'cat' ? 'Mèo' : 'Chó',
                            onTap: _pickSpecies,
                          ),
                          const SizedBox(width: 10),
                          FilterChipButton(
                            icon: Icons.fitness_center,
                            label: _selectedWeight,
                            onTap: _pickWeight,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Tabs =====
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: HomeColors.primaryDark,
                  unselectedLabelColor: Colors.grey[800],
                  indicatorColor: HomeColors.primaryDark,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w900),
                  tabs: const [
                    Tab(text: 'Combo'),
                    Tab(text: 'Dịch vụ lẻ'),
                  ],
                ),
              ),

              // ===== Content =====
              Expanded(
                child: TabBarView(
                  children: [
                    // ===== Combos =====
                    combos.isEmpty
                        ? const Center(child: Text('Chưa có combo.'))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            itemCount: combos.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final combo = combos[i];
                              final estPrice = _estimateComboPrice(
                                combo,
                                singleByName,
                              );

                              return ComboMenuCard(
                                title: combo.name,
                                items: combo.itemsResolved,
                                priceText: _formatPrice(estPrice),
                                onTap: () => _openBookingSheet(
                                  title: combo.name,
                                  items: combo.itemsResolved,
                                  price: estPrice,
                                ),
                              );
                            },
                          ),

                    // ===== Singles =====
                    singles.isEmpty
                        ? const Center(child: Text('Chưa có dịch vụ lẻ.'))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            itemCount: singles.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final svc = singles[i];
                              final price = _priceForSingleService(svc);

                              return MenuCard(
                                icon: Icons.cut,
                                title: svc.name,
                                subtitle: 'Giá thay đổi theo loài & cân nặng',
                                trailingTop: _formatPrice(price),
                                trailingBottom: 'Nhấn để đặt',
                                onTap: () => _openBookingSheet(
                                  title: svc.name,
                                  items: [svc.name],
                                  price: price,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== Pricing =====

  int _estimateComboPrice(
    ServiceDoc combo,
    Map<String, ServiceDoc> singleByName,
  ) {
    int total = 0;
    for (final name in combo.itemsResolved) {
      final svc = singleByName[name];
      if (svc == null) continue;
      total += _priceForSingleService(svc);
    }
    return total;
  }

  int _priceForSingleService(ServiceDoc? svc) {
    final base = _selectedSpecies == 'dog'
        ? (svc?.dogBase ?? 10000)
        : (svc?.catBase ?? 10000);

    final price = base + _weightIncrement();
    return (price / 1000).round() * 1000;
  }

  int _weightIncrement() {
    switch (_selectedWeight) {
      case '<5kg':
        return 0;
      case '<10kg':
        return 10000;
      case '<20kg':
        return 25000;
      case '>=20kg':
        return 40000;
      default:
        return 0;
    }
  }

  // ===== Format =====

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

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
