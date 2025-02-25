// Dynamic import de chai (ESM/CommonJS compatibility)
let chai;
let expect;
(async () => {
  chai = await import('chai');
  expect = chai.expect;
})();

const request = require('supertest');
const app = require('../app'); 


const AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImRjNjI2MmYzZTk3NzIzOWMwMDUzY2ViODY0Yjc3NDBmZjMxZmNkY2MiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiY2FtaWxhIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL2JhbmNhLW1vdmlsLTkzMTY1IiwiYXVkIjoiYmFuY2EtbW92aWwtOTMxNjUiLCJhdXRoX3RpbWUiOjE3NDAzNjQ3ODcsInVzZXJfaWQiOiJ4UDM2YTFlMUtjZWh2TTVLdll3d3Y0a1ljUDAyIiwic3ViIjoieFAzNmExZTFLY2Vodk01S3ZZd3d2NGtZY1AwMiIsImlhdCI6MTc0MDM2NDc4OCwiZXhwIjoxNzQwMzY4Mzg4LCJlbWFpbCI6ImNhbWlsYXNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImNhbWlsYXNAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.gtzuH3Haz_unemivS2aa-e7lUIyVexg-VcIlgFrnyrs50l3tPZoxvJseOvn1w1Hlbzvhn2QMaVPpq6GtuEaQur0cxXV1eh1QxCrT6HLqOpys-qIAii_irJY52GbJjfAgBthpSuatCI6VdEL1bx7hZhJgVfHT2xdplmZp1NQi0M0VldKzxpx5GbIV3tNwzmbVzoTg1x7ywGo7mGOZMsRFTgNP-fj9ZUOB0nSIhC8qgIbFCGgA2vzaGcXLnFkACKu6Nxpw3UNEjMMbIGauST-rgFRQjRr1A3FJ-wxwitTQkDMPlx91snz966TzZvQTAAV895e82hWmzT5cikiy7lh3qg"; 

describe('Payments API', function () {
  let testUserId = 5; 
  let testCardId = 2; 

  // Probar procesamiento de pago con datos válidos
  it('Debería procesar un pago exitosamente', async function () {
    const validPaymentData = {
      userId: testUserId,
      cardId: testCardId,
      amount: 100.50
    };

    const res = await request(app)
      .post('/api/payments')
      .set('Authorization', AUTH_TOKEN) 
      .set('Content-Type', 'application/json') 
      .send(validPaymentData);

    expect(res.status).to.equal(201);
    expect(res.body).to.have.property('message', 'Pago realizado con éxito.');
    expect(res.body).to.have.property('paymentId');
    expect(res.body).to.have.property('transactionId');
  });

  // Probar procesamiento de pago con datos inválidos
  it('No debería procesar un pago con datos inválidos', async function () {
    const invalidPaymentData = {
      userId: testUserId,
      amount: -50.00 
    };

    const res = await request(app)
      .post('/api/payments')
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json')
      .send(invalidPaymentData);

    expect(res.status).to.be.oneOf([400, 500]); 
    expect(res.body).to.have.any.keys('error', 'message'); 
  });

  //  Probar generación de historial de transacciones en JSON
  it('Debería obtener el historial de transacciones', async function () {
    const res = await request(app)
      .get(`/api/transactions/${testUserId}`)
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json');

    expect(res.status).to.equal(200);
    expect(res.body).to.be.an('array');
  });
});
