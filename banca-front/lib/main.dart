import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/card_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/notification_controller.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización para Web (o Desktop)
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCb-XlBQOCzLWNpsp47Nufr-1cyg1u5Nuc",
      authDomain: "banca-movil-93165.firebaseapp.com",
      projectId: "banca-movil-93165",
      storageBucket: "banca-movil-93165.firebasestorage.app",
      messagingSenderId: "405218291958",
      appId: "1:405218291958:web:02070e77aaebaca453bcd7",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CardController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: MaterialApp(
        title: 'Banca Móvil',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}
