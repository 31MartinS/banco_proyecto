// models/userModel.js
const db = require('../config/db');

const User = {
  async create(name, email, password) {
    return await db.query(
      'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
      [name, email, password]
    );
  },

  async findByEmail(email) {
    const result = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    return result[0]; // Retorna el primer registro (o undefined)
  },

  async findById(id) {
    const result = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    return result[0];
  }
};

module.exports = User;
