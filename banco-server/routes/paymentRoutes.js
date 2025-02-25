// routes/paymentRoutes.js
const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const authenticateFirebaseToken = require('../middleware/authFirebase');

// Realizar un pago (protegido)
router.post('/', authenticateFirebaseToken, paymentController.makePayment);

module.exports = router;
