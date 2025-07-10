import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reservastion/screen/ThankyouPage.dart';
import 'package:reservastion/screen/date_management.dart';
import 'package:reservastion/screen/forgot_password.dart';
import 'package:reservastion/screen/order_history.dart';
import 'package:reservastion/screen/order_in.dart';
import 'package:reservastion/screen/root_page.dart';
import 'package:reservastion/screen/admin_dashboard.dart';
import 'screen/signup.dart';
import 'screen/login.dart';
import 'screen/home.dart';
import 'screen/paket.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? "",
      appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? "",
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? "",
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? "",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      initialRoute: '/',
      routes: {
        '/': (context) => const RootPage(),
        '/login': (context) => const LoginScreen(),
        '/sign-up': (context) => const SignUpPage(),
        '/paket': (context) => const PaketPage(),
        '/home': (context) => const HomePage(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/success': (context) => const ThankYouPage(),
        '/order-history': (context) => OrderHistory(),
        '/order-in': (context) => const OrderIn(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/date-management': (context) => const DateManagement(),
      },
    );
  }
}
