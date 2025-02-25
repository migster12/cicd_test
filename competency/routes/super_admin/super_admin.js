const express = require('express')
const router = express.Router();

const authRoutes = require('./auth');
const regionRoutes = require('./region');
const divisionRoutes = require('./division');
const userRoutes = require('./user');
const provinceRoutes = require('./province');
const scc = require('./scc');
const municipality = require('./municipality');
const message = require('./message');
const position = require('./position');
const dashboard = require('./dashboard');

router.use('/sadmin', authRoutes);
router.use('/sadmin', regionRoutes);
router.use('/sadmin', divisionRoutes);
router.use('/sadmin', userRoutes);
router.use('/sadmin', provinceRoutes);
router.use('/sadmin', scc);
router.use('/sadmin', municipality);
router.use('/sadmin', message);
router.use('/sadmin', position);
router.use('/sadmin', dashboard);

module.exports = router;