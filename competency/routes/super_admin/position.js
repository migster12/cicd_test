const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addPosition = require("../../controller/super_admin/system_management/positions/addPosition");
const getAllPosition = require("../../controller/super_admin/system_management/positions/getAllPosition");
const getPositionByID = require("../../controller/super_admin/system_management/positions/getPositionByID");
const updatePositionByID = require("../../controller/super_admin/system_management/positions/updatePositionByID");
const disablePosition = require("../../controller/super_admin/system_management/positions/disablePosition");
const enablePosition = require("../../controller/super_admin/system_management/positions/enablePosition");

// -------- Models ---------------
const getAllSchema = require('../../models/shared/getAllSchema');
const getByIDSchema = require('../../models/shared/getByIDSchema');
const addPositionSchema = require('../../models/super_admin/addPosition');


router.route('/position')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addPositionSchema}), (req,res) => {
    addPosition(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllSchema}), (req,res) => {
    getAllPosition(req,res)
})

router.route('/position/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    getPositionByID(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema, body: addPositionSchema}), (req,res) => {
    updatePositionByID(req,res)
})

router.route('/disable/position/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    disablePosition(req,res)
})
router.route('/enable/position/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    enablePosition(req,res)
})

module.exports = router;