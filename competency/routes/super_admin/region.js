const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addRegion = require("../../controller/super_admin/system_management/region/addRegion");
const getAllRegion = require("../../controller/super_admin/system_management/region/getAllRegion");
const getRegionByID = require("../../controller/super_admin/system_management/region/getRegionByID");
const updateRegionByID = require("../../controller/super_admin/system_management/region/updateRegionByID");
const changeRegionStatus = require("../../controller/super_admin/system_management/region/changeRegionStatus");
const allUserByRegionDD = require("../../controller/super_admin/system_management/region/allUserByRegionDD");

// -------- Models ---------------
const addRegionSchema = require('../../models/super_admin/addRegion');
const getAllRegionsSchema = require('../../models/super_admin/getAllRegionsSchema');
const getRegionByIDSchema = require('../../models/super_admin/getRegionByIDSchema');
const updateRegionSchema = require('../../models/super_admin/updateRegionSchema');
const changeRegionStatusSchema = require('../../models/super_admin/changeRegionStatusSchema');


router.route('/region')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addRegionSchema}), (req,res) => {
    addRegion(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllRegionsSchema}), (req,res) => {
    getAllRegion(req,res)
})

router.route('/region/:regionID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getRegionByIDSchema}), (req,res) => {
    getRegionByID(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getRegionByIDSchema, body: updateRegionSchema}), (req,res) => {
    updateRegionByID(req,res)
})
.patch(passport.authenticate('jwt', {session : false}),validator.validate({params: getRegionByIDSchema, body: changeRegionStatusSchema}), (req,res) => {
    changeRegionStatus(req,res)
})

router.route('/users/region/:regionID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getRegionByIDSchema}), (req,res) => {
    allUserByRegionDD(req,res)
})

module.exports = router;