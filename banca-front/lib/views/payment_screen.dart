import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/card_controller.dart';
import '../controllers/payment_controller.dart';
import '../models/card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amountController = TextEditingController();
  String? _errorMessage;
  CardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    // Asegúrate de que las tarjetas se hayan cargado previamente,
    // o bien, puedes forzar la carga en este initState si es necesario:
    final authController = Provider.of<AuthController>(context, listen: false);
    final cardController = Provider.of<CardController>(context, listen: false);
    if (authController.currentUser != null && authController.idToken != null) {
      cardController.userId = authController.currentUser!.id;
      cardController.fetchCards(authController.idToken!).then((_) {
        if (cardController.cards.isNotEmpty) {
          setState(() {
            _selectedCard = cardController.cards.first;
          });
        }
      });
    }
  }

  void _confirmPayment() {
    // Validamos el monto
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Por favor, ingresa un monto válido mayor a cero';
      });
      return;
    }
    if (_selectedCard == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una tarjeta';
      });
      return;
    }
    setState(() {
      _errorMessage = null;
    });

    // Muestra el diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Pago'),
        content: const Text('¿Desea confirmar el pago?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final authController = Provider.of<AuthController>(context, listen: false);
              final paymentController = Provider.of<PaymentController>(context, listen: false);
              Map<String, dynamic> paymentData = {
                'userId': authController.currentUser!.id,
                'cardId': _selectedCard!.id,
                'amount': amount,
              };
              bool success = await paymentController.makePayment(paymentData, authController.idToken!);
              Navigator.pop(context); // Cierra el dialogo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? 'Pago realizado con éxito' : 'Error al procesar pago')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardController = Provider.of<CardController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Realizar Pago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para el monto
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown para seleccionar la tarjeta
            cardController.cards.isEmpty
                ? const Text('No hay tarjetas disponibles')
                : DropdownButtonFormField<CardModel>(
              decoration: const InputDecoration(
                labelText: 'Selecciona la tarjeta',
                border: OutlineInputBorder(),
              ),
              value: _selectedCard,
              items: cardController.cards.map((card) {
                // Mostramos solo los últimos 4 dígitos para identificar la tarjeta
                String displayText = card.cardNumber;
                return DropdownMenuItem<CardModel>(
                  value: card,
                  child: Text(displayText),
                );
              }).toList(),
              onChanged: (CardModel? newValue) {
                setState(() {
                  _selectedCard = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmPayment,
                child: const Text('Pagar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
