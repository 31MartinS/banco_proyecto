import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'card_management_screen.dart';
import 'login_screen.dart';
import 'payment_screen.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define las páginas a mostrar según la pestaña seleccionada
  final List<Widget> _pages = const [
    PaymentScreen(),
    TransactionHistoryScreen(),
    CardManagementScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Construye el Drawer con información del usuario y navegación
  Widget _buildDrawer(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authController.currentUser?.name ?? ''),
            accountEmail: Text(authController.currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                authController.currentUser?.name.substring(0, 1) ?? '',
                style: const TextStyle(fontSize: 40, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pagar'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Tarjetas'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              // Cierra la sesión
              final authController = Provider.of<AuthController>(context, listen: false);
              authController.logout();
              // Navega a LoginScreen eliminando todas las rutas anteriores
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('BanQuito',style: TextStyle(color: Colors.white),),
      ),
      drawer: _buildDrawer(context),
      body: user == null
          ? const Center(child: Text('No hay usuario'))
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pagar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Tarjetas',
          ),
        ],
      ),
    );
  }
}
