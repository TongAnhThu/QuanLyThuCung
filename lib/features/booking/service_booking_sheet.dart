import 'package:flutter/material.dart';

class ServiceBookingResult {
  final String customerName;
  final String phone;
  final String petName;
  final DateTime date;
  final TimeOfDay time;
  final String note;

  final String serviceTitle;
  final List<String> serviceItems;
  final String species;
  final String weight;
  final int? price;

  ServiceBookingResult({
    required this.customerName,
    required this.phone,
    required this.petName,
    required this.date,
    required this.time,
    required this.note,
    required this.serviceTitle,
    required this.serviceItems,
    required this.species,
    required this.weight,
    this.price,
  });
}

Future<ServiceBookingResult?> showServiceBookingSheet({
  required BuildContext context,
  required String serviceTitle,
  required List<String> serviceItems,
  required String species,
  required String weight,
  int? price,
  Color primaryColor = const Color(0xFF1E90FF),
}) {
  return showModalBottomSheet<ServiceBookingResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (_) => _ServiceBookingSheet(
      serviceTitle: serviceTitle,
      serviceItems: serviceItems,
      species: species,
      weight: weight,
      price: price,
      primaryColor: primaryColor,
    ),
  );
}

class _ServiceBookingSheet extends StatefulWidget {
  final String serviceTitle;
  final List<String> serviceItems;
  final String species;
  final String weight;
  final int? price;
  final Color primaryColor;

  const _ServiceBookingSheet({
    required this.serviceTitle,
    required this.serviceItems,
    required this.species,
    required this.weight,
    required this.price,
    required this.primaryColor,
  });

  @override
  State<_ServiceBookingSheet> createState() => _ServiceBookingSheetState();
}

class _ServiceBookingSheetState extends State<_ServiceBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _petCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _petCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _fmtPrice(int? v) {
    if (v == null) return '—';
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      final rem = (idx - 1) % 3;
      if (rem == 0 && i != s.length - 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày và giờ.')),
      );
      return;
    }

    final result = ServiceBookingResult(
      customerName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      petName: _petCtrl.text.trim(),
      date: _date!,
      time: _time!,
      note: _noteCtrl.text.trim(),
      serviceTitle: widget.serviceTitle,
      serviceItems: widget.serviceItems,
      species: widget.species,
      weight: widget.weight,
      price: widget.price,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.event_available, color: widget.primaryColor),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Đặt lịch dịch vụ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: widget.primaryColor.withOpacity(0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(
                              'Loài: ${widget.species == 'dog' ? 'Chó' : 'Mèo'}',
                            ),
                            _chip('Cân nặng: ${widget.weight}'),
                            _chip('Giá: ${_fmtPrice(widget.price)}'),
                          ],
                        ),
                        if (widget.serviceItems.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          ...widget.serviceItems
                              .take(8)
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: widget.primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          e,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _field(
                          controller: _nameCtrl,
                          label: 'Họ và tên',
                          icon: Icons.person,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Vui lòng nhập họ tên'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        _field(
                          controller: _phoneCtrl,
                          label: 'Số điện thoại',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return 'Vui lòng nhập số điện thoại';
                            if (s.length < 9)
                              return 'Số điện thoại chưa hợp lệ';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _field(
                          controller: _petCtrl,
                          label: 'Tên thú cưng',
                          icon: Icons.pets,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Vui lòng nhập tên thú cưng'
                              : null,
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _pickCard(
                                title: 'Ngày',
                                value: _date == null
                                    ? 'Chọn ngày'
                                    : _fmtDate(_date!),
                                icon: Icons.calendar_month,
                                onTap: _pickDate,
                                color: widget.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _pickCard(
                                title: 'Giờ',
                                value: _time == null
                                    ? 'Chọn giờ'
                                    : _fmtTime(_time!),
                                icon: Icons.access_time,
                                onTap: _pickTime,
                                color: widget.primaryColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        _field(
                          controller: _noteCtrl,
                          label: 'Ghi chú (tuỳ chọn)',
                          icon: Icons.notes,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _submit,
                            child: const Text(
                              'Xác nhận đặt lịch',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _pickCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
          color: color.withOpacity(0.06),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
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
}
