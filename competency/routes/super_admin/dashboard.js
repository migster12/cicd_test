const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const getDashboard = require("../../controller/super_admin/dashboard/getDashboard");

// -------- Models ---------------


router.route('/dashboard')
.get(passport.authenticate('jwt', {session : false}), (req,res) => {
    getDashboard(req,res)
})

module.exports = router;