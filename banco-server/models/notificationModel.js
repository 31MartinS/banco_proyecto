// models/notificationModel.js
const db = require('../config/db');

const Notification = {
  async create(userId, message) {
    return await db.query(
      'INSERT INTO notifications (user_id, message) VALUES (?, ?)',
      [userId, message]
    );
  },

  async findByUserId(userId) {
    return await db.query('SELECT * FROM notifications WHERE user_id = ?', [userId]);
  },

  async markAsRead(id) {
    return await db.query('UPDATE notifications SET is_read = TRUE WHERE id = ?', [id]);
  }
};

module.exports = Notification;
