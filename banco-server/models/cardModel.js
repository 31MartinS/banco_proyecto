// models/cardModel.js
const db = require('../config/db');

const Card = {
  // Devuelve todas las tarjetas del usuario (en un array)
  async findAllByUser(userId) {
    return await db.query('SELECT * FROM cards WHERE user_id = ?', [userId]);
  },

  // Crea una tarjeta; se espera un objeto con las propiedades
  async create({ user_id, card_number, expiry_date, cardholder_name }) {
    return await db.query(
      'INSERT INTO cards (user_id, card_number, expiry_date, cardholder_name) VALUES (?, ?, ?, ?)',
      [user_id, card_number, expiry_date, cardholder_name]
    );
  },

  async delete(id) {
    return await db.query('DELETE FROM cards WHERE id = ?', [id]);
  },

  async freeze(id) {
    return await db.query('UPDATE cards SET is_frozen = TRUE WHERE id = ?', [id]);
  },

  async unfreeze(id) {
    return await db.query('UPDATE cards SET is_frozen = FALSE WHERE id = ?', [id]);
  }
};

module.exports = Card;
