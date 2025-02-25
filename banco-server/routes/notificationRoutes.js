// routes/notificationRoutes.js
const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const authenticateFirebaseToken = require('../middleware/authFirebase');

// Listar notificaciones de un usuario (protegido)
router.get('/:userId', authenticateFirebaseToken, notificationController.listNotifications);

// Marcar notificación como leída (protegido)
router.put('/:id/read', authenticateFirebaseToken, notificationController.markAsRead);

module.exports = router;
