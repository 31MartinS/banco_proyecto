// config/db.js
const mysql = require('mysql2');
const util = require('util');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',        
  password: 'password',  
  database: 'banco'
});

// Permite usar async/await en las consultas
pool.query = util.promisify(pool.query).bind(pool);

module.exports = pool;
