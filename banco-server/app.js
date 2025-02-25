// app.js
const express = require('express');
const cors = require('cors');

// Instancia de Express
const app = express();

// Middlewares
app.use(express.json());
app.use(cors());

// Importar rutas
const userRoutes = require('./routes/userRoutes');
const cardRoutes = require('./routes/cardRoutes');
const paymentRoutes = require('./routes/paymentRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
const notificationRoutes = require('./routes/notificationRoutes');

// Asignar prefijos a las rutas
app.use('/api/users', userRoutes);
app.use('/api/cards', cardRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/notifications', notificationRoutes);

// Exportar la app (sin listen)
module.exports = app;
