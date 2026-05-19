const axios = require('axios');
const baseUrl = process.env.BASE_URL || 'http://localhost:4000';

async function run() {
  console.log('Running API smoke tests against', baseUrl);
  try {
    // register
    const email = `test+${Date.now()}@example.com`;
    console.log('Registering', email);
    const reg = await axios.post(`${baseUrl}/api/auth/register`, {
      fullname: 'Test User', businessName: 'Toko Test', email, password: 'password123'
    });
    console.log('Register response:', reg.data && reg.data.user ? 'OK' : reg.status);

    // login
    const login = await axios.post(`${baseUrl}/api/auth/login`, { email, password: 'password123' });
    const token = login.data.token;
    console.log('Login successful. Token length:', token ? token.length : 0);

    const authHeaders = { headers: { Authorization: `Bearer ${token}` } };

    // create transaction
    const tx = await axios.post(`${baseUrl}/api/transactions`, {
      type: 'income', category: 'Penjualan', amount: 100000, description: 'Pembelian awal', paymentMethod: 'Cash', transactionDate: new Date().toISOString()
    }, authHeaders);
    console.log('Create transaction response id:', tx.data.data && tx.data.data._id ? tx.data.data._id : tx.status);

    // get transactions
    const list = await axios.get(`${baseUrl}/api/transactions`, authHeaders);
    console.log('Transactions count for user:', Array.isArray(list.data.data) ? list.data.data.length : 'unknown');

    // analytics daily
    const daily = await axios.get(`${baseUrl}/api/analytics/daily`, authHeaders);
    console.log('Daily analytics items:', Array.isArray(daily.data.data) ? daily.data.data.length : 'unknown');

    console.log('\nAll tests ran. If you saw expected outputs above, the API works correctly.');
  } catch (err) {
    if (err.response) {
      console.error('API error', err.response.status, err.response.data);
    } else {
      console.error('Error', err.message);
    }
    process.exit(1);
  }
}

run();
