// controllers/transactionController.js
const Transaction = require('../models/transactionModel');

const transactionController = {
  async listTransactions(req, res) {
    try {
      const { userId } = req.params;
      const transactions = await Transaction.findByUserId(userId);
      res.json(transactions);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al obtener transacciones' });
    }
  }
};

module.exports = transactionController;
