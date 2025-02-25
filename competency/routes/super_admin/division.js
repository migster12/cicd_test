const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addDivision = require("../../controller/super_admin/system_management/division/addDivision");
const getAllDivision = require("../../controller/super_admin/system_management/division/getAllDivision");
const getDivisionByID = require("../../controller/super_admin/system_management/division/getDivisionByID");
const updateDivisionByID = require("../../controller/super_admin/system_management/division/updateDivisionByID");
const changeDivisionStatus = require("../../controller/super_admin/system_management/division/changeDivisionStatus");
const ddgetAllRegion = require("../../controller/super_admin/system_management/division/ddgetAllRegion");
const allUserByRegIDandDivID = require("../../controller/super_admin/system_management/division/allUserByRegIDandDivID");

// -------- Models ---------------
const addDivisionSchema = require('../../models/super_admin/addDivision');
const getAllDivisionSchema = require('../../models/super_admin/getAllDivisionSchema');
const getDivisionByIDSchema = require('../../models/super_admin/getAllDivisionByID');
const updateDivisionSchema = require('../../models/super_admin/updateDivisionSchema');
const changeDivisionStatusSchema = require('../../models/super_admin/changeDivisionStatusSchema');
const getAllUserByRegIDAndDivIDSchema = require('../../models/super_admin/getAllUserByRegIDAndDivIDSchema');


router.route('/division')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addDivisionSchema}), (req,res) => {
    addDivision(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllDivisionSchema}), (req,res) => {
    getAllDivision(req,res)
})

router.route('/division/:divisionID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getDivisionByIDSchema}), (req,res) => {
    getDivisionByID(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getDivisionByIDSchema, body: updateDivisionSchema}), (req,res) => {
    updateDivisionByID(req,res)
})
.patch(passport.authenticate('jwt', {session : false}),validator.validate({params: getDivisionByIDSchema, body: changeDivisionStatusSchema}), (req,res) => {
    changeDivisionStatus(req,res)
})

router.route('/dd/region')
.get(passport.authenticate('jwt', {session : false}), (req,res) => {
    ddgetAllRegion(req,res)
})

router.route('/users/division/:regionID/:divID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getAllUserByRegIDAndDivIDSchema}), (req,res) => {
    allUserByRegIDandDivID(req,res)
})

module.exports = router;