// controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');
const { JWT_SECRET } = require('../middleware/authMiddleware');

const authController = {
  async register(req, res) {
    try {
      const { name, email, password } = req.body;
      const existingUser = await User.findByEmail(email);
      if (existingUser) {
        return res.status(400).json({ message: 'El email ya está registrado.' });
      }
      const hashedPassword = await bcrypt.hash(password, 10);
      await User.create({ name, email, password: hashedPassword });
      res.status(201).json({ message: 'Usuario registrado exitosamente.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al registrar usuario' });
    }
  },

  async login(req, res) {
    try {
      const { email, password } = req.body;
      const user = await User.findByEmail(email);
      if (!user) {
        return res.status(400).json({ message: 'Credenciales incorrectas.' });
      }
      const validPassword = await bcrypt.compare(password, user.password);
      if (!validPassword) {
        return res.status(400).json({ message: 'Credenciales incorrectas.' });
      }
      const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });
      res.json({ token, user: { id: user.id, name: user.name, email: user.email, balance: user.balance } });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error al iniciar sesión' });
    }
  }
};

module.exports = authController;
