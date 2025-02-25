// routes/transactionRoutes.js
const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const authenticateFirebaseToken = require('../middleware/authFirebase');

// Listar transacciones de un usuario (protegido)
router.get('/:userId', authenticateFirebaseToken, transactionController.listTransactions);

module.exports = router;
