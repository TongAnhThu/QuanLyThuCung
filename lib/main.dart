import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';

import 'features/auth/login/login_page.dart';
import 'features/auth/login/register_page.dart';
import 'features/auth/login/forgot_page.dart';
import 'features/auth/login/first_time_setup_page.dart';

import 'features/home/widgets/home_page.dart';

import 'features/pets/pet_detail_page.dart';
import 'features/cart/cart_page.dart';
import 'features/cart/checkout_page.dart';
import 'features/cart/purchase_history_page.dart';

import 'features/posts/post_detail_page.dart';
import 'features/items/item_detail_page.dart';

import 'Profile/ProfilePage.dart';
import 'Profile/EditProfile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase init error: $e');
  }

  // Only initialize OneSignal on mobile platforms (not web)
  if (!kIsWeb) {
    try {
      OneSignal.initialize("fa52c4a8-bd81-4bf0-9bd1-d136ee283e0f");
      await OneSignal.Notifications.requestPermission(true);
      print('OneSignal initialized successfully');
    } catch (e) {
      print('OneSignal init error: $e');
    }
  }

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

      initialRoute: LoginPage.routeName,

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case PetDetailPage.routeName:
            final pet = settings.arguments;
            if (pet is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => PetDetailPage(pet: pet),
                settings: settings,
              );
            }
            if (pet is Map) {
              return MaterialPageRoute(
                builder: (_) => PetDetailPage(
                  pet: pet.map((k, v) => MapEntry(k.toString(), v)),
                ),
                settings: settings,
              );
            }
            return _errorRoute('Thiếu dữ liệu thú cưng (pet).');

          case PostDetailPage.routeName:
            return MaterialPageRoute(
              builder: (_) => const PostDetailPage(),
              settings: settings,
            );

          case ItemDetailPage.routeName:
            return MaterialPageRoute(
              builder: (_) => const ItemDetailPage(),
              settings: settings,
            );

          default:
            return null;
        }
      },

      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        ForgotPage.routeName: (_) => const ForgotPage(),
        FirstTimeSetupPage.routeName: (_) => const FirstTimeSetupPage(),
        HomePage.routeName: (_) => const HomePage(),
        CartPage.routeName: (_) => const CartPage(),
        CheckoutPage.routeName: (_) => const CheckoutPage(),
        PurchaseHistoryPage.routeName: (_) => const PurchaseHistoryPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        EditProfilePage.routeName: (_) => const EditProfilePage(),
      },
    );
  }

  static MaterialPageRoute _errorRoute(String message) {
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
