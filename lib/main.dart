import 'package:appshopbanthucung/features/items/item_detail_page.dart';
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/auth/forgot_page.dart';
import 'features/home/home_page.dart';
import 'features/pets/pet_detail_page.dart';
import 'features/cart/cart_page.dart';
import 'features/posts/post_detail_page.dart';
import 'Profile/ProfilePage.dart';
import 'Profile/EditProfile.dart';
import 'features/items/item_detail_page.dart';
import 'features/booking/service_booking_sheet.dart';

void main() {
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
        if (settings.name == PetDetailPage.routeName) {
          final pet = settings.arguments as Map<String, String>;
          return MaterialPageRoute(builder: (_) => PetDetailPage(pet: pet));
        }
        if (settings.name == PostDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => const PostDetailPage(),
            settings: settings,
          );
        }
        return null;
      },
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        ForgotPage.routeName: (_) => const ForgotPage(),
        HomePage.routeName: (_) => const HomePage(),
        CartPage.routeName: (_) => const CartPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        EditProfilePage.routeName: (_) => const EditProfilePage(),
        ItemDetailPage.routeName: (_) => const ItemDetailPage(),
      },
    );
  }
}
