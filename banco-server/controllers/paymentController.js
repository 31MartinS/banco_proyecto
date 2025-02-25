const Payment = require('../models/paymentModel');
const Transaction = require('../models/transactionModel');
const Notification = require('../models/notificationModel');

const paymentController = {
    async makePayment(req, res) {
        try {
            const { userId, cardId, amount } = req.body;

            if (!userId || !cardId || !amount) {
                return res.status(400).json({ message: 'Faltan datos obligatorios.' });
            }

            // Crear el pago y obtener su ID
            const paymentId = await Payment.create(userId, cardId, amount, 'completed');

            console.log('  paymentId generado:', paymentId);

            if (!paymentId) {
                throw new Error('  No se pudo generar un paymentId válido.');
            }

            // Crear la transacción (Asegurar que paymentId se pase correctamente)
            const transactionId = await Transaction.create(paymentId, 'Pago realizado', amount);

            console.log('  Transacción creada con ID:', transactionId);

            // Crear la notificación
            await Notification.create(userId, `Pago de $${amount} realizado.`);

            res.status(201).json({
                message: 'Pago realizado con éxito.',
                paymentId,
                transactionId
            });

        } catch (error) {
            console.error('  Error detallado en makePayment:', error);
            res.status(500).json({ error: error.message || 'Error al procesar el pago' });
        }
    }
};

module.exports = paymentController;
