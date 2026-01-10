import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'theme/app_theme.dart';

import 'features/auth/login/login_page.dart';
import 'features/auth/login/register_page.dart';
import 'features/auth/login/forgot_page.dart';

import 'features/home/widgets/home_page.dart';

import 'features/pets/pet_detail_page.dart';
import 'features/cart/cart_page.dart';

import 'features/posts/post_detail_page.dart';
import 'features/items/item_detail_page.dart';

import 'Profile/ProfilePage.dart';
import 'Profile/EditProfile.dart';
import 'services/onesignal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.initialize("fa52c4a8-bd81-4bf0-9bd1-d136ee283e0f");
  await OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Shop Bán Thú Cưng',
      theme: AppTheme.lightTheme,

      // ✅ dùng initialRoute theo routeName chuẩn
      initialRoute: LoginPage.routeName,

      // ✅ onGenerateRoute: xử lý các route cần arguments
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case PetDetailPage.routeName:
            final pet = settings.arguments;
            if (pet is Map<String, String>) {
              return MaterialPageRoute(
                builder: (_) => PetDetailPage(pet: pet),
                settings: settings,
              );
            }
            // fallback nếu args sai
            return _errorRoute('Thiếu dữ liệu thú cưng (pet).');

          case PostDetailPage.routeName:
            final post = settings.arguments;
            // Nếu PostDetailPage của cậu có constructor nhận post:
            // return MaterialPageRoute(builder: (_) => PostDetailPage(post: post as Map<String,String>), settings: settings);
            // Còn nếu PostDetailPage đang tự lấy arguments trong build via ModalRoute thì giữ const cũng được:
            return MaterialPageRoute(
              builder: (_) => const PostDetailPage(),
              settings: settings,
            );

          case ItemDetailPage.routeName:
            final item = settings.arguments;
            // Nếu ItemDetailPage của cậu có constructor nhận item:
            // return MaterialPageRoute(builder: (_) => ItemDetailPage(item: item as Map<String,String>), settings: settings);
            return MaterialPageRoute(
              builder: (_) => const ItemDetailPage(),
              settings: settings,
            );

          default:
            return null;
        }
      },

      // ✅ routes: các route không cần arguments
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        ForgotPage.routeName: (_) => const ForgotPage(),
        HomePage.routeName: (_) => const HomePage(),
        CartPage.routeName: (_) => const CartPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        EditProfilePage.routeName: (_) => const EditProfilePage(),
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Lỗi điều hướng')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
