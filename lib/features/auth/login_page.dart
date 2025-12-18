import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'widgets/auth_card.dart';
import 'widgets/gradient_background.dart';
import 'register_page.dart';
import '../home/home_page.dart';
import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _staySignedIn = true;
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: AuthCard(
              title: 'Đăng nhập',
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _usernameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Tên đăng nhập / ID',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Vui lòng nhập tên đăng nhập'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Vui lòng nhập mật khẩu'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _staySignedIn,
                            activeColor: AppColors.primaryDark,
                            onChanged: (v) =>
                                setState(() => _staySignedIn = v ?? false),
                          ),
                          const Text(
                            'Giữ đăng nhập',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              ForgotPage.routeName,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Quên tài khoản hoặc mật khẩu?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      GradientButton(
                        label: 'LOGIN',
                        onPressed: () {
                          // UI-only phase: bỏ qua xác thực và đăng nhập thật
                          // Navigator sẽ chuyển sang trang chủ ngay khi bấm
                          Navigator.pushReplacementNamed(
                            context,
                            HomePage.routeName,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white),
                            children: [
                              const TextSpan(text: 'Chưa có tài khoản? '),
                              TextSpan(
                                text: 'Tạo tài khoản',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                    context,
                                    RegisterPage.routeName,
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
          ),
        ),
      ),
    );
  }
}
