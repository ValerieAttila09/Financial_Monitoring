# UPSM Backend

Simple Node.js + Express backend for the UPSM (Monitoring Keuangan Harian UMKM) app.

Requirements
- Node.js 16+
- MongoDB

Setup

1. Copy `.env.example` to `.env` and set values.
2. Install dependencies:

```
npm install
```

3. Run in development:

```
npm run dev
```

Available endpoints
- POST /api/auth/register
- POST /api/auth/login
- GET /api/auth/profile (protected)
- GET /api/transactions
- POST /api/transactions
- PUT /api/transactions/:id
- DELETE /api/transactions/:id
- GET /api/analytics/daily
- GET /api/analytics/monthly

Notes
- This is a minimal scaffold. Add input sanitization, rate limiting, and production hardening before deploying.