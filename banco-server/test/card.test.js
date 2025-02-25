// Dynamic import de chai (ESM/CommonJS compatibility)
let chai;
let expect;
(async () => {
  chai = await import('chai');
  expect = chai.expect;
})();

const request = require('supertest');
const app = require('../app');

const AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImRjNjI2MmYzZTk3NzIzOWMwMDUzY2ViODY0Yjc3NDBmZjMxZmNkY2MiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiY2FtaWxhIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL2JhbmNhLW1vdmlsLTkzMTY1IiwiYXVkIjoiYmFuY2EtbW92aWwtOTMxNjUiLCJhdXRoX3RpbWUiOjE3NDAzNjE5MTYsInVzZXJfaWQiOiJ4UDM2YTFlMUtjZWh2TTVLdll3d3Y0a1ljUDAyIiwic3ViIjoieFAzNmExZTFLY2Vodk01S3ZZd3d2NGtZY1AwMiIsImlhdCI6MTc0MDM2MTkxNiwiZXhwIjoxNzQwMzY1NTE2LCJlbWFpbCI6ImNhbWlsYXNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImNhbWlsYXNAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.tY1LT_ZjF9k-4D8IvVbnAzF7zDSkZ0n7Looy3PKTSu8BeRfSkhOmR8lhdc6sGc7oD1U7MxZmvT5s6n2_v0ZsUgY-XzdPu-ZH6rOmapwqb4Wf0pNQSYzw8kvsQHYrcj2IO-t-eN2Cft5ihICKY_GNK_1ilWsT02CTlkgm3eFhKwq89BTCzryE4kUI6zK8T2-ZRdayWVZogAwqvQLfADgi9U96Xk-ld7PdCMGkmx-zbQJOw3FwGOM34DcRPFDX3W3UUdjusvvHZCs7PdYAoigm2-N-gHF3qQjeOAgd4rDXsvU0ZRYX-Y5ncNM8FdS3Na8o083IBXl0zRKorg95J1SNZg"; 

describe('Cards API', function () {
  let testUserId = 7;
  let createdCardId

  // 1) Probar agregar una tarjeta con datos válidos
  it('Debería agregar una tarjeta con datos válidos', async function () {
    const validCardData = {
      userId: testUserId,
      cardNumber: '1234567812345678',
      expiryDate: '2025-12-31',
      cardholderName: 'Juan Perez'
    };

    const res = await request(app)
      .post('/api/cards')
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json')
      .send(validCardData);

    expect(res.status).to.equal(201);
    expect(res.body).to.have.property('message', 'Tarjeta agregada.');

    // Obtener ID de la tarjeta creada si es devuelta en la respuesta
    if (res.body.cardId) {
      createdCardId = res.body.cardId;
    } else {
      // Obtener la tarjeta creada listando todas
      const listRes = await request(app)
        .get(`/api/cards/${testUserId}`)
        .set('Authorization', AUTH_TOKEN);
        
      expect(listRes.status).to.equal(200);
      expect(listRes.body).to.be.an('array');
      createdCardId = listRes.body[listRes.body.length - 1].id;
    }
  });

  // 2️) Probar agregar tarjeta con datos inválidos
  it('No debería agregar tarjeta con datos inválidos', async function () {
    const invalidCardData = {
      userId: testUserId,
      expiryDate: '12/28', // Falta 'cardNumber'
      cardholderName: 'Sin Numero'
    };

    const res = await request(app)
      .post('/api/cards')
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json')
      .send(invalidCardData);

    expect(res.status).to.be.oneOf([400, 500]);
    expect(res.body).to.have.property('error');
  });

  // 3️) Probar congelar una tarjeta y verificar is_frozen
  it('Debería congelar una tarjeta y verificar is_frozen', async function () {
    if (!createdCardId) {
      throw new Error('No se pudo obtener un ID de tarjeta válida para congelar.');
    }

    // 🔹 Congelar tarjeta
    const freezeRes = await request(app)
      .put(`/api/cards/${createdCardId}/freeze`)
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json');

    expect(freezeRes.status).to.equal(200);
    expect(freezeRes.body).to.have.property('message', 'Tarjeta congelada.');

    // Verificar que la tarjeta ahora está congelada
    const afterFreezeList = await request(app)
      .get(`/api/cards/${testUserId}`)
      .set('Authorization', AUTH_TOKEN);

    expect(afterFreezeList.status).to.equal(200);
    const updatedCards = afterFreezeList.body;
    const frozenCard = updatedCards.find(c => c.id === createdCardId);
    expect(frozenCard).to.exist;
    expect(frozenCard.is_frozen).to.equal(1); // 1 significa congelada
  });

  // 4️) Probar descongelar una tarjeta y verificar is_frozen
  it('Debería descongelar una tarjeta y verificar is_frozen', async function () {
    if (!createdCardId) {
      throw new Error('No se pudo obtener un ID de tarjeta válida para descongelar.');
    }

    // 🔹 Descongelar tarjeta
    const unfreezeRes = await request(app)
      .put(`/api/cards/${createdCardId}/unfreeze`)
      .set('Authorization', AUTH_TOKEN)
      .set('Content-Type', 'application/json');

    expect(unfreezeRes.status).to.equal(200);
    expect(unfreezeRes.body).to.have.property('message', 'Tarjeta descongelada.');

    // Verificar que la tarjeta ahora está descongelada
    const afterUnfreezeList = await request(app)
      .get(`/api/cards/${testUserId}`)
      .set('Authorization', AUTH_TOKEN);

    expect(afterUnfreezeList.status).to.equal(200);
    const updatedCards = afterUnfreezeList.body;
    const unfrozenCard = updatedCards.find(c => c.id === createdCardId);
    expect(unfrozenCard).to.exist;
    expect(unfrozenCard.is_frozen).to.equal(0); // 0 significa no congelada
  });
});
