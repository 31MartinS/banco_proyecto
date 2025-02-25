// routes/cardRoutes.js
const express = require('express');
const router = express.Router();
const cardController = require('../controllers/cardController');
const authenticateFirebaseToken = require('../middleware/authFirebase');

// Listar tarjetas (protegido)
router.get('/:userId', authenticateFirebaseToken, cardController.listCards);
// Agregar tarjeta (protegido)
router.post('/', authenticateFirebaseToken, cardController.addCard);
// Eliminar tarjeta (protegido)
router.delete('/:id', authenticateFirebaseToken, cardController.deleteCard);
// Congelar tarjeta (protegido)
router.put('/:id/freeze', authenticateFirebaseToken, cardController.freezeCard);
// Descongelar tarjeta (protegido)
router.put('/:id/unfreeze', authenticateFirebaseToken, cardController.unfreezeCard);

module.exports = router;
