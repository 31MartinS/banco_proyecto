// controllers/cardController.js
const Card = require('../models/cardModel');

const cardController = {
  async listCards(req, res) {
    try {
      const { userId } = req.params;
      // Usamos findAllByUser (ya definido en el modelo)
      const cards = await Card.findAllByUser(userId);
      res.json(cards); // Asegúrate de que "cards" es un array
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al obtener tarjetas' });
    }
  },
  async addCard(req, res) {
    try {
      // Extraer con camelCase
      const { userId, cardNumber, expiryDate, cardholderName } = req.body;
      // Mapear a snake_case para la base de datos:
      await Card.create({
        user_id: userId,
        card_number: cardNumber,
        expiry_date: expiryDate,
        cardholder_name: cardholderName,
      });
      res.status(201).json({ message: 'Tarjeta agregada.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al agregar tarjeta' });
    }
  },
  
  async deleteCard(req, res) {
    try {
      const { id } = req.params;
      await Card.delete(id);
      res.json({ message: 'Tarjeta eliminada.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al eliminar tarjeta' });
    }
  },
  async freezeCard(req, res) {
    try {
      const { id } = req.params;
      await Card.freeze(id);
      res.json({ message: 'Tarjeta congelada.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al congelar tarjeta' });
    }
  },
  async unfreezeCard(req, res) {
    try {
      const { id } = req.params;
      await Card.unfreeze(id);
      res.json({ message: 'Tarjeta descongelada.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al descongelar tarjeta' });
    }
  }
};

module.exports = cardController;
