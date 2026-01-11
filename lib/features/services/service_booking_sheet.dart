import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/booking_model.dart';
import '../../../theme/home_colors.dart';

Future<dichvuModel?> showServiceBookingSheet({
  required BuildContext context,
  required Color primaryColor,
  required String serviceTitle,
  required List<String> serviceItems,
  required String species,
  required String weight,
  int? price,
  String userId = '',
}) async {
  return showModalBottomSheet<dichvuModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      return _ServiceBookingSheetBody(
        primaryColor: primaryColor,
        serviceTitle: serviceTitle,
        serviceItems: serviceItems,
        species: species,
        weight: weight,
        price: price,
        userId: userId,
      );
    },
  );
}

class _ServiceBookingSheetBody extends StatefulWidget {
  const _ServiceBookingSheetBody({
    required this.primaryColor,
    required this.serviceTitle,
    required this.serviceItems,
    required this.species,
    required this.weight,
    required this.price,
    required this.userId,
  });

  final Color primaryColor;
  final String serviceTitle;
  final List<String> serviceItems;
  final String species;
  final String weight;
  final int? price;
  final String userId;

  @override
  State<_ServiceBookingSheetBody> createState() =>
      _ServiceBookingSheetBodyState();
}

class _ServiceBookingSheetBodyState extends State<_ServiceBookingSheetBody> {
  // === ràng buộc giờ làm ===
  static const int _openHour = 9;
  static const int _closeHour = 19; // 19:00 là giờ cuối có thể đặt

  final _customerNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _petCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    // để summary cập nhật theo input
    _customerNameCtrl.addListener(_refresh);
    _phoneCtrl.addListener(_refresh);
    _petCtrl.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _customerNameCtrl.removeListener(_refresh);
    _phoneCtrl.removeListener(_refresh);
    _petCtrl.removeListener(_refresh);

    _customerNameCtrl.dispose();
    _phoneCtrl.dispose();
    _petCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  bool _isValidPhone(String s) {
    // VN phổ biến: 10 số, bắt đầu bằng 0
    final phone = s.trim();
    return RegExp(r'^0\d{9}$').hasMatch(phone);
  }

  bool _isInWorkingHours(TimeOfDay t) {
    final total = t.hour * 60 + t.minute;
    final open = _openHour * 60;
    final close = _closeHour * 60; // 19:00
    return total >= open && total <= close;
  }

  bool get _canSubmit {
    final nameOk = _customerNameCtrl.text.trim().isNotEmpty;
    final petOk = _petCtrl.text.trim().isNotEmpty;
    final phoneOk = _isValidPhone(_phoneCtrl.text);
    final timeOk = _isInWorkingHours(_time);
    return nameOk && petOk && phoneOk && timeOk;
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 14,
          bottom: 14 + pad,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              widget.serviceTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),

            if (widget.price != null)
              Text(
                'Giá ước tính: ${_formatPrice(widget.price!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: HomeColors.primaryDark,
                ),
              ),

            const SizedBox(height: 10),
            Text(
              'Shop sẽ gọi xác nhận sau khi bạn đặt lịch.',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _customerNameCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Tên người đặt',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: 'Số điện thoại (liên hệ)',
                border: const OutlineInputBorder(),
                errorText:
                    _phoneCtrl.text.isEmpty || _isValidPhone(_phoneCtrl.text)
                    ? null
                    : 'SĐT không hợp lệ ',
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _petCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Tên thú cưng ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _pickTile(
                    title: 'Ngày',
                    value: _formatDate(_date),
                    icon: Icons.calendar_month,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _date,
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _pickTile(
                    title: 'Giờ (09:00–19:00)',
                    value: _formatTime(_time),
                    icon: Icons.schedule,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );
                      if (picked == null) return;

                      if (!_isInWorkingHours(picked)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Shop chỉ nhận 09:00–19:00'),
                          ),
                        );
                        return; // không set giờ
                      }

                      setState(() => _time = picked);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (tuỳ chọn)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ TÓM TẮT ĐẶT LỊCH
            _summaryCard(),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  disabledBackgroundColor: widget.primaryColor.withOpacity(
                    0.45,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _canSubmit
                    ? () {
                        final result = dichvuModel(
                          userId: widget.userId,
                          serviceTitle: widget.serviceTitle,
                          serviceItems: widget.serviceItems,
                          species: widget.species,
                          weight: widget.weight,

                          bookingname: _customerNameCtrl.text.trim(),
                          bookingphone: _phoneCtrl.text.trim(),

                          petName: _petCtrl.text.trim(),
                          date: _date,
                          time: _time,
                          price: widget.price,
                          note: _noteCtrl.text.trim().isEmpty
                              ? null
                              : _noteCtrl.text.trim(),
                          id: '',
                          createdAt: null,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Đã gửi yêu cầu đặt lịch. Shop sẽ liên hệ xác nhận.',
                            ),
                          ),
                        );

                        Navigator.pop(context, result);
                      }
                    : null,
                child: const Text(
                  'Xác nhận đặt lịch',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    final name = _customerNameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final pet = _petCtrl.text.trim();

    String maskPhone(String s) {
      if (s.length < 7) return s;
      return '${s.substring(0, 3)}****${s.substring(s.length - 3)}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.primaryColor.withOpacity(0.25)),
        color: widget.primaryColor.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt đặt lịch',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text('Boss: ${pet.isEmpty ? '—' : pet}'),
          Text('Thời gian: ${_formatDate(_date)} · ${_formatTime(_time)}'),
          Text(
            'Liên hệ: ${name.isEmpty ? '—' : name} · ${phone.isEmpty ? '—' : maskPhone(phone)}',
          ),
          Text(
            'Dịch vụ: ${widget.serviceItems.isEmpty ? widget.serviceTitle : widget.serviceItems.join(', ')}',
          ),
          if (!_isInWorkingHours(_time))
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Lưu ý: giờ đặt ngoài 09:00–19:00',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _pickTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.primaryColor.withOpacity(0.25)),
          color: widget.primaryColor.withOpacity(0.04),
        ),
        child: Row(
          children: [
            Icon(icon, color: widget.primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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
