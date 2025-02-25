// controllers/userController.js
const admin = require('../config/firebase'); // Asegúrate de tener configurado Firebase Admin
const User = require('../models/userModel');

const userController = {
  // Registro de usuario
  async register(req, res) {
    try {
      const { name, email, password } = req.body;

      // Verificar si el email ya está registrado en tu base local
      const existingUser = await User.findByEmail(email);
      if (existingUser) {
        return res.status(400).json({ message: 'El email ya está registrado.' });
      }

      // Crear usuario en Firebase Authentication
      const firebaseUser = await admin.auth().createUser({
        email,
        password,
        displayName: name,
      });

      // Imprime en consola para depuración (esto te ayudará a ver que se creó en Firebase)
      console.log('Usuario creado en Firebase:', firebaseUser);

      // Guardar datos adicionales en MySQL (aquí podrías guardar firebaseUser.uid si lo necesitas)
      await User.create(name, email, password);

      res.status(201).json({ message: 'Usuario registrado con éxito.', uid: firebaseUser.uid });
    } catch (error) {
      console.error('Error en register:', error);
      res.status(500).json({ error: 'Error al registrar usuario' });
    }
  },

  // Inicio de sesión
  async login(req, res) {
    try {
      const { email, password } = req.body;
      const user = await User.findByEmail(email);

      if (!user) {
        return res.status(400).json({ message: 'Credenciales incorrectas.' });
      }

      // Comparar contraseña en texto plano (no recomendado en producción)
      if (user.password !== password) {
        return res.status(400).json({ message: 'Credenciales incorrectas.' });
      }

      // Devolvemos la información básica del usuario
      res.json({
        message: 'Inicio de sesión exitoso.',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          balance: user.balance
        }
      });
    } catch (error) {
      console.error('Error en login:', error);
      res.status(500).json({ error: 'Error al iniciar sesión' });
    }
  },

  // Obtener info de un usuario
  async getUser(req, res) {
    try {
      const { id } = req.params;
      const user = await User.findById(id);

      if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado.' });
      }

      res.json({
        id: user.id,
        name: user.name,
        email: user.email,
        balance: user.balance
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al obtener usuario' });
    }
  }
};

module.exports = userController;
