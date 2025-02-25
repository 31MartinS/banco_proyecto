// middleware/authFirebase.js
const admin = require('../config/firebase'); // Asegúrate de que la ruta es correcta

async function authenticateFirebaseToken(req, res, next) {
  try {
    const authHeader = req.headers.authorization || '';
    const token = authHeader.split(' ')[1]; // Se espera el formato "Bearer <token>"

    if (!token) {
      return res.status(401).json({ error: 'No se proporcionó token de Firebase.' });
    }

    // Verificar el token usando Firebase Admin SDK
    const decodedToken = await admin.auth().verifyIdToken(token);

    // Almacenar datos del usuario en req.user (por ejemplo, uid y email)
    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
    };

    next();
  } catch (error) {
    console.error('Error al verificar token de Firebase:', error);
    return res.status(403).json({ error: 'Token de Firebase inválido o expirado.' });
  }
}

module.exports = authenticateFirebaseToken;
