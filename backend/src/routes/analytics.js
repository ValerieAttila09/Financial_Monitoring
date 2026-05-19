const express = require('express');
const Transaction = require('../models/Transaction');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Daily summary for recent days
router.get('/daily', authMiddleware, async (req, res) => {
  try {
    // return sums grouped by day for last 7 days
    const userId = req.user._id;
    const days = 7;
    const from = new Date();
    from.setDate(from.getDate() - (days - 1));
    from.setHours(0,0,0,0);

    const pipeline = [
      { $match: { userId, transactionDate: { $gte: from } } },
      { $project: { amount: 1, type: 1, day: { $dateToString: { format: "%Y-%m-%d", date: "$transactionDate" } } } },
      { $group: { _id: { day: "$day", type: "$type" }, total: { $sum: "$amount" } } }
    ];

    const results = await Transaction.aggregate(pipeline);
    res.json({ data: results });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Monthly summary: grouped by month for last 6 months
router.get('/monthly', authMiddleware, async (req, res) => {
  try {
    const userId = req.user._id;
    const from = new Date();
    from.setMonth(from.getMonth() - 5);
    from.setDate(1);
    from.setHours(0,0,0,0);

    const pipeline = [
      { $match: { userId, transactionDate: { $gte: from } } },
      { $project: { amount: 1, type: 1, month: { $dateToString: { format: "%Y-%m", date: "$transactionDate" } } } },
      { $group: { _id: { month: "$month", type: "$type" }, total: { $sum: "$amount" } } }
    ];

    const results = await Transaction.aggregate(pipeline);
    res.json({ data: results });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
