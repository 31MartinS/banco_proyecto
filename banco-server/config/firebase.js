// config/firebase.js
const admin = require("firebase-admin");

const serviceAccount = require("../banca-movil-93165-firebase-adminsdk-fbsvc-2330f9d2ee.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

module.exports = admin;
