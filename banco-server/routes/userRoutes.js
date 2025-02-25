// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authenticateFirebaseToken = require('../middleware/authFirebase');

// Registro (público)
router.post('/register', userController.register);

// Inicio de sesión (público)
router.post('/login', userController.login);

// Obtener datos de un usuario por ID (protegido)
router.get('/:id', authenticateFirebaseToken, userController.getUser);

module.exports = router;
