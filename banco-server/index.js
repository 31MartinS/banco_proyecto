// index.js
const app = require('./app');
const port = 3000;

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
