import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/card_controller.dart';
import '../models/card.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({Key? key}) : super(key: key);

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurarnos de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final cardController = Provider.of<CardController>(context, listen: false);
      // Asumimos que el CardController tiene su propiedad userId ya configurada (o se pasa desde el authController)
      if (authController.currentUser != null && authController.idToken != null) {
        cardController.userId = authController.currentUser!.id;
        cardController.fetchCards(authController.idToken!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardController = Provider.of<CardController>(context);
    final authController = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Tarjetas')),
      body: cardController.cards.isEmpty
          ? const Center(child: Text('No hay tarjetas registradas.'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: cardController.cards.length,
        itemBuilder: (context, index) {
          CardModel card = cardController.cards[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildCardWidget(card, authController),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _mostrarFormularioAgregar(context);
        },
      ),
    );
  }

  Widget _buildCardWidget(CardModel card, AuthController authController) {
    // Gradientes personalizados:
    // Tarjeta activa: degradado índigo
    final activeGradient = const LinearGradient(
      colors: [Color(0xFF283593), Color(0xFF3F51B5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    // Tarjeta congelada: degradado gris
    final frozenGradient = const LinearGradient(
      colors: [Color(0xFF424242), Color(0xFF616161)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: card.isFrozen ? frozenGradient : activeGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: número de tarjeta y botones de bloqueo/desbloqueo y borrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        card.isFrozen ? Icons.lock : Icons.lock_open,
                        color: Colors.white,
                      ),
                      tooltip: card.isFrozen ? "Tarjeta congelada" : "Tarjeta activa",
                      onPressed: () async {
                        bool success = false;
                        if (card.isFrozen) {
                          // Si está congelada, descongelar
                          success = await Provider.of<CardController>(context, listen: false)
                              .unfreezeCard(
                            cardId: card.id.toString(),
                            idToken: authController.idToken!,
                          );
                        } else {
                          // Si está activa, congelar
                          success = await Provider.of<CardController>(context, listen: false)
                              .freezeCard(
                            cardId: card.id.toString(),
                            idToken: authController.idToken!,
                          );
                        }
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al actualizar estado de la tarjeta')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      tooltip: "Eliminar tarjeta",
                      onPressed: () async {
                        bool success = await Provider.of<CardController>(context, listen: false)
                            .deleteCard(
                          cardId: card.id.toString(),
                          idToken: authController.idToken!,
                        );
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al eliminar tarjeta')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Fila inferior: Fecha de expiración y nombre del titular
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exp: ${_formatDate(card.expiryDate)}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  card.cardholderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formatea la fecha para mostrar solo "yyyy-MM-dd"
  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  void _mostrarFormularioAgregar(BuildContext context) {
    final _cardNumberController = TextEditingController();
    final _expiryDateController = TextEditingController();
    final _cardholderNameController = TextEditingController();
    final authController = Provider.of<AuthController>(context, listen: false);
    final cardController = Provider.of<CardController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Número de Tarjeta'),
            ),
            TextField(
              controller: _expiryDateController,
              decoration: const InputDecoration(labelText: 'Fecha de Expiración (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _cardholderNameController,
              decoration: const InputDecoration(labelText: 'Nombre del Titular'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              bool success = await cardController.addCard(
                cardNumber: _cardNumberController.text,
                expiryDate: _expiryDateController.text,
                cardholderName: _cardholderNameController.text,
                idToken: authController.idToken!,
              );
              if (success) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al agregar tarjeta')),
                );
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
