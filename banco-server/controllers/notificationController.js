// controllers/notificationController.js
const Notification = require('../models/notificationModel');

const notificationController = {
  async listNotifications(req, res) {
    try {
      const { userId } = req.params;
      const notifications = await Notification.findByUserId(userId);
      res.json(notifications);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al obtener notificaciones' });
    }
  },

  async markAsRead(req, res) {
    try {
      const { id } = req.params;
      await Notification.markAsRead(id);
      res.json({ message: 'Notificación marcada como leída.' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al actualizar notificación' });
    }
  }
};

module.exports = notificationController;
