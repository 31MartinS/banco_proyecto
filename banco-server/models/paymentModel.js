// models/paymentModel.js
const db = require('../config/db');

const Payment = {
  async create(userId, cardId, amount, status) {
    const result = await db.query(
      'INSERT INTO payments (user_id, card_id, amount, status) VALUES (?, ?, ?, ?)',
      [userId, cardId, amount, status]
    );
    console.log('Pago registrado. ID generado:', result.insertId);
    return result.insertId; // ID del nuevo registro
  }
};

module.exports = Payment;
