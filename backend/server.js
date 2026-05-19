require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

// simple request logger
function requestLogger(req, res, next) {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.originalUrl}`);
  next();
}
const mongoose = require('mongoose');

const authRoutes = require('./src/routes/auth');
const transactionRoutes = require('./src/routes/transactions');
const analyticsRoutes = require('./src/routes/analytics');

const app = express();
// dev-friendly CORS - restrict in production
app.use(cors({ origin: true, credentials: true }));
app.use(express.json());
app.use(requestLogger);

app.use('/api/auth', authRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/analytics', analyticsRoutes);

// error handler - always return JSON
app.use(function errorHandler(err, req, res, next) {
  console.error('Unhandled error:', err && err.stack ? err.stack : err);
  const status = err.status || 500;
  const payload = { message: err.message || 'Internal Server Error' };
  // include validation details if present
  if (err.errors) payload.errors = err.errors;
  if (process.env.NODE_ENV !== 'production') payload.stack = err.stack;
  res.status(status).json(payload);
});

const PORT = process.env.PORT || 4000;

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('MongoDB connection error', err);
  });
