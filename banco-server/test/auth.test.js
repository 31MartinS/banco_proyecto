// test/auth.test.js

let chai;
let expect;
(async () => {
  chai = await import('chai');
  expect = chai.expect;
})();

const request = require('supertest');
const app = require('../app'); 

describe('Auth API', function () {

  // 1) Registrar un nuevo usuario
  it('Debería registrar un nuevo usuario con datos válidos', async function () {
    const newUser = {
      name: 'silvana',              
      email: 'silvanas@gmail.com',   
      password: '123456'
    };

    const res = await request(app)
      .post('/api/users/register')   
      .send(newUser);

    // Esperamos que el servidor devuelva 201
    expect(res.status).to.equal(201);

    expect(res.body).to.have.property('message', 'Usuario registrado con éxito.');
    expect(res.body).to.have.property('uid').that.is.a('string');
  });

  // 2) Intentar iniciar sesión con credenciales INCORRECTAS
  it('No debería iniciar sesión con credenciales incorrectas', async function () {
    const invalidCredentials = {
      email: 'rigoberts@gmail.com',
      password: 'contrasena_incorrecta'
    };

    const res = await request(app)
      .post('/api/users/login')        
      .send(invalidCredentials);

    expect(res.status).to.equal(400);
    expect(res.body).to.have.property('message', 'Credenciales incorrectas.');
  });

  // 3) Inicio de sesión EXITOSO
  it('Debería iniciar sesión con credenciales correctas', async function () {
    const validCredentials = {
      email: 'rigoberts@gmail.com',
      password: '123456'
    };

    const res = await request(app)
      .post('/api/users/login')
      .send(validCredentials);

    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('message', 'Inicio de sesión exitoso.');
    expect(res.body).to.have.property('user');

    const user = res.body.user;
    expect(user).to.have.property('id').that.is.a('number');     
    expect(user).to.have.property('name', 'rigorbert');
    expect(user).to.have.property('email', 'rigoberts@gmail.com');
    expect(user).to.have.property('balance', '0.00');             
  });

});
