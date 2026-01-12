import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/model/service_booking_item.dart';

class UserServiceBookingsPage extends StatefulWidget {
  const UserServiceBookingsPage({super.key});
  static const String routeName = '/user-my-bookings';

  @override
  State<UserServiceBookingsPage> createState() =>
      _UserServiceBookingsPageState();
}

class _UserServiceBookingsPageState extends State<UserServiceBookingsPage> {
  final _searchCtrl = TextEditingController();
  String _keyword = '';
  bool _showPast = false; // false = sắp tới, true = đã qua

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _keyword = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _bookingsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }

    return FirebaseFirestore.instance
        .collection(ServiceBookingItem.col)
        .where(ServiceBookingItem.fUserId, isEqualTo: uid)
        .snapshots();
  }

  bool _isPast(DateTime startAt) => startAt.isBefore(DateTime.now());

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  String _fmtTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$hh:$mi';
  }

  String _fmtPrice(int price) {
    if (price <= 0) return '';
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

  Color _statusColor(String s) {
    final v = s.toLowerCase();
    if (v.contains('confirm')) return Colors.green;
    if (v.contains('done') || v.contains('complete')) return Colors.blue;
    if (v.contains('cancel')) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch dịch vụ đã đăng ký')),
      body: uid == null
          ? const Center(child: Text('Bạn chưa đăng nhập'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Tìm theo dịch vụ, boss...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Sắp tới'),
                        selected: !_showPast,
                        onSelected: (_) => setState(() => _showPast = false),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Đã qua'),
                        selected: _showPast,
                        onSelected: (_) => setState(() => _showPast = true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _bookingsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Lỗi tải lịch: ${snapshot.error}'),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text('Chưa có lịch dịch vụ'),
                        );
                      }

                      // parse -> filter
                      final items = <ServiceBookingItem>[];
                      for (final doc in docs) {
                        final it = ServiceBookingItem.fromDoc(doc);

                        final okPast = _showPast
                            ? _isPast(it.startAt)
                            : !_isPast(it.startAt);

                        final key = _keyword;
                        final searchBlob =
                            ('${it.serviceTitle} ${it.petName} ${it.serviceItems.join(' ')}')
                                .toLowerCase();

                        final okKey = key.isEmpty || searchBlob.contains(key);

                        if (okPast && okKey) items.add(it);
                      }

                      if (items.isEmpty) {
                        return const Center(
                          child: Text('Không có kết quả phù hợp'),
                        );
                      }

                      // sort
                      items.sort((a, b) {
                        final cmp = a.startAt.compareTo(b.startAt);
                        return _showPast ? -cmp : cmp;
                      });

                      // group theo ngày
                      final Map<DateTime, List<ServiceBookingItem>> grouped =
                          {};
                      for (final it in items) {
                        grouped.putIfAbsent(it.dayOnly, () => []);
                        grouped[it.dayOnly]!.add(it);
                      }

                      final days = grouped.keys.toList()
                        ..sort(
                          (a, b) => _showPast ? b.compareTo(a) : a.compareTo(b),
                        );

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final day = days[index];
                          final list = grouped[day] ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _fmtDate(day),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              for (final it in list)
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.event_note_outlined,
                                    ),
                                    title: Text(
                                      it.serviceTitle.isNotEmpty
                                          ? it.serviceTitle
                                          : (it.serviceItems.isNotEmpty
                                                ? it.serviceItems.join(', ')
                                                : '(Không có dịch vụ)'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Boss: ${it.petName.isEmpty ? '—' : it.petName}\n'
                                        '${_fmtTime(it.startAt)} - ${_fmtTime(it.endAt)}'
                                        '${it.price > 0 ? ' • ${_fmtPrice(it.price)}' : ''}',
                                        maxLines: 3,
                                      ),
                                    ),
                                    isThreeLine: true,
                                    trailing: Chip(
                                      label: Text(it.status),
                                      backgroundColor: _statusColor(
                                        it.status,
                                      ).withOpacity(0.15),
                                      labelStyle: TextStyle(
                                        color: _statusColor(it.status),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    // ✅ đã xoá snackbar: không onTap
                                  ),
                                ),
                              const SizedBox(height: 6),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
