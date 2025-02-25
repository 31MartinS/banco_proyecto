// models/transactionModel.js
const db = require('../config/db');

const Transaction = {
  async create(paymentId, details, amount) {
    if (!paymentId) {
      throw new Error('  paymentId no puede ser null antes de insertar en transactions.');
    }

    console.log('  Insertando transacción con paymentId:', paymentId);

    try {
      // Corrección: Usar `query()` en lugar de `execute()`
      const query = `INSERT INTO transactions (payment_id, details, amount) VALUES (?, ?, ?)`;
      console.log('  SQL Query:', query);
      console.log('  Valores:', [paymentId, details, amount]);

      // PROBAR CON query() en lugar de execute()
      const result = await db.query(query, [paymentId, details, amount]);

      console.log('🔍 Resultado de la consulta:', result);

      if (!result || !result.insertId) {
        throw new Error('  La consulta no devolvió un resultado válido.');
      }

      console.log('  Transacción registrada con ID:', result.insertId);
      return result.insertId;
    } catch (error) {
      console.error('  Error en Transaction.create:', error);
      throw new Error('Error al insertar la transacción en la base de datos.');
    }
  },
  async findByUserId(userId) {
    return await db.query(
      `SELECT t.*, p.payment_date, p.status 
       FROM transactions t 
       JOIN payments p ON t.payment_id = p.id 
       WHERE p.user_id = ?
       ORDER BY p.payment_date DESC`,
      [userId]
    );
  }
};

module.exports = Transaction;
