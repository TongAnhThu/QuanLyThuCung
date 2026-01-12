import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/profile-edit';
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const String kUsersCol = 'users'; // ✅ đổi nếu DB cậu khác

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _addressCtrl = TextEditingController();

    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final ref = FirebaseFirestore.instance
          .collection(kUsersCol)
          .doc(user.uid);
      final snap = await ref.get();

      final data = snap.data() ?? {};

      // ✅ fill controller (fallback hợp lý)
      _nameCtrl.text = (data['displayName'] ?? user.displayName ?? 'Pet Lover')
          .toString();
      _emailCtrl.text = (data['email'] ?? user.email ?? '').toString();
      _phoneCtrl.text = (data['phoneNumber'] ?? '').toString();
      _addressCtrl.text = (data['address'] ?? '').toString();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải profile: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    try {
      final ref = FirebaseFirestore.instance
          .collection(kUsersCol)
          .doc(user.uid);

      final payload = <String, dynamic>{
        'displayName': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(), // thường giữ nguyên
        'phoneNumber': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        // 'avatarUrl': ... nếu sau này có upload avatar
      };

      await ref.set(payload, SetOptions(merge: true));

      if (!mounted) return;

      // ✅ Pop về + báo ProfilePage reload
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lưu thất bại: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Lưu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            enabled: false,
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
                              if (s.isEmpty)
                                return 'Vui lòng nhập số điện thoại';
                              if (s.length < 9)
                                return 'Số điện thoại không hợp lệ';
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
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.withOpacity(0.08),
      ),
    );
  }
}
