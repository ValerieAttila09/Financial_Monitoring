const express = require('express');
const { body, validationResult } = require('express-validator');
const Transaction = require('../models/Transaction');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Get transactions (with optional filters)
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { startDate, endDate, category, type, q } = req.query;
    const filter = { userId: req.user._id };
    if (type) filter.type = type;
    if (category) filter.category = category;
    if (startDate || endDate) filter.transactionDate = {};
    if (startDate) filter.transactionDate.$gte = new Date(startDate);
    if (endDate) filter.transactionDate.$lte = new Date(endDate);
    if (q) filter.$or = [{ description: new RegExp(q, 'i') }, { category: new RegExp(q, 'i') }];
    const items = await Transaction.find(filter).sort({ transactionDate: -1 });
    res.json({ data: items });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create transaction
router.post('/', authMiddleware, [
  body('type').isIn(['income', 'expense']),
  body('category').notEmpty(),
  body('amount').isNumeric(),
  body('transactionDate').notEmpty()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  try {
    const tx = new Transaction({ ...req.body, userId: req.user._id });
    await tx.save();
    res.json({ data: tx });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Update transaction
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    const tx = await Transaction.findOneAndUpdate({ _id: req.params.id, userId: req.user._id }, req.body, { new: true });
    if (!tx) return res.status(404).json({ message: 'Not found' });
    res.json({ data: tx });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete transaction
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    const tx = await Transaction.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
    if (!tx) return res.status(404).json({ message: 'Not found' });
    res.json({ message: 'Deleted' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
