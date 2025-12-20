import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/profile-edit';
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    final user = (args is Map<String, dynamic>) ? args : <String, dynamic>{};

    // set dữ liệu ban đầu (chỉ set 1 lần nếu đang rỗng)
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = (user['name'] ?? 'Pet Lover').toString();
      _emailCtrl.text = (user['email'] ?? 'petshop@example.com').toString();
      _phoneCtrl.text = (user['phone'] ?? '').toString();
      _addressCtrl.text = (user['address'] ?? '').toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
    };

    Navigator.pop(context, updated); // ✅ trả dữ liệu về ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Họ và tên',
                      hint: 'Ví dụ: Pet Lover',
                      icon: Icons.person_outline,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Vui lòng nhập họ và tên';
                        if (s.length < 2) return 'Tên quá ngắn';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'petshop@example.com',
                      icon: Icons.email_outlined,
                      enabled: false, // thường email không cho sửa
                      validator: (_) => null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Số điện thoại',
                      hint: 'Ví dụ: 09xxxxxxxx',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Vui lòng nhập số điện thoại';
                        if (s.length < 9) return 'Số điện thoại không hợp lệ';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _addressCtrl,
                      label: 'Địa chỉ',
                      hint: 'Ví dụ: Quận 1, TP.HCM',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Vui lòng nhập địa chỉ';
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lưu thay đổi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
