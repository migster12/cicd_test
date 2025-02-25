const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');

// -------- Functions ---------------
const register = require("../../controller/super_admin/auth/register");
const login = require("../../controller/super_admin/auth/login");

// -------- Models ---------------
const registerSchema = require('../../models/super_admin/registerSchema');
const loginSchema = require('../../models/super_admin/loginSchema');


router.route('/login')
.post(validator.validate({body: loginSchema}), (req,res) => {
    login(req,res)
})

router.route('/register')
.post(validator.validate({body: registerSchema}), (req,res) => {
    register(req,res)
})

module.exports = router;