const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addUser = require("../../controller/super_admin/user_management/add_user");
const updateUser = require("../../controller/super_admin/user_management/updateUser");
const getAllUser = require("../../controller/super_admin/user_management/getAllUser");

// -------- Models ---------------
const addUserSchema = require('../../models/super_admin/addUserSchema');
const updateUserSchema = require('../../models/super_admin/updateUserSchema');
const getAllSchema = require('../../models/shared/getAllSchema');


router.route('/user')
.post(passport.authenticate('jwt', {session : false}), validator.validate({body: addUserSchema}), (req,res) => {
    addUser(req,res)
})
.get(passport.authenticate('jwt', {session : false}), validator.validate({query: getAllSchema}), (req,res) => {
    getAllUser(req,res)
})

router.route('/user/:uid')
.put(passport.authenticate('jwt', {session : false}), validator.validate({body: updateUserSchema}), (req,res) => {
    updateUser(req,res)
})

module.exports = router;