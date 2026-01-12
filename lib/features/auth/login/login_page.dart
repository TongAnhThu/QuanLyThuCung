import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../widgets/auth_card.dart';
import '../widgets/gradient_background.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'register_page.dart';
import '../../home/widgets/home_page.dart';
import 'forgot_page.dart';
import 'first_time_setup_page.dart';

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
  final _authService = AuthService();
  final _userService = UserService();
  bool _staySignedIn = true;
  bool _obscure = true;
  bool _isLoading = false;

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
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _staySignedIn,
                                  activeColor: AppColors.primaryDark,
                                  onChanged: (v) => setState(
                                    () => _staySignedIn = v ?? false,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Giữ đăng nhập',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              ForgotPage.routeName,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              minimumSize: const Size(0, 36),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              'Quên mật khẩu?',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      GradientButton(
                        label: _isLoading ? 'ĐANG ĐĂNG NHẬP...' : 'LOGIN',
                        onPressed: _isLoading ? null : () => _handleLogin(),
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
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Hoặc tiếp tục với',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _handleGoogleSignIn(),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Google'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _handleAnonymousSignIn(),
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Tiếp tục ẩn danh'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInWithEmailPassword(
        email: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (credential?.user == null || !mounted) return;

      // Kiểm tra profile trong Firestore
      final userProfile = await _userService.getUserProfile(
        credential!.user!.uid,
      );

      if (!mounted) return;

      // Nếu profile chưa hoàn tất hoặc chưa tồn tại, đưa sang trang setup
      if (userProfile == null || !userProfile.isProfileComplete) {
        Navigator.pushReplacementNamed(
          context,
          FirstTimeSetupPage.routeName,
          arguments: {
            'uid': credential.user!.uid,
            'displayName':
                userProfile?.displayName ?? credential.user!.displayName ?? '',
            'email': credential.user!.email ?? '',
          },
        );
      } else {
        // Profile đã hoàn tất, vào trang chủ
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInWithGoogle();

      // user bấm huỷ / không lấy được user
      if (!mounted) return;
      if (credential == null || credential.user == null) return;

      // ✅ Đơn giản nhất: vào thẳng Home
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAnonymousSignIn() async {
    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInAnonymously();

      if (credential == null || credential.user == null || !mounted) return;

      // Tạo profile mới cho anonymous user
      await _userService.createUserProfile(
        uid: credential.user!.uid,
        email: credential.user!.email ?? 'anonymous@example.com',
        displayName: 'Anonymous User',
      );

      if (!mounted) return;

      // Đưa sang trang setup để hoàn tất thông tin
      Navigator.pushReplacementNamed(
        context,
        FirstTimeSetupPage.routeName,
        arguments: {
          'uid': credential.user!.uid,
          'displayName': 'Anonymous User',
          'email': credential.user!.email ?? '',
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
