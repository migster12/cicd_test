const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addSCC = require("../../controller/super_admin/system_management/scc/addSCC");
const getAllSCC = require("../../controller/super_admin/system_management/scc/getAllSCC");
const getSCCByID = require("../../controller/super_admin/system_management/scc/getSCCByID");
const changeSCCStatus = require("../../controller/super_admin/system_management/scc/changeSCCStatus");
const updateSCCByID = require("../../controller/super_admin/system_management/scc/updateSCCByID");
const ddgetAllProvinceByRegion = require("../../controller/super_admin/system_management/scc/ddgetAllProvinceByRegion");
const allUsersByRegIDandprovID = require("../../controller/super_admin/system_management/province/allUsersByRegIDandprovID");

// -------- Models ---------------
const addSCCSchema = require('../../models/super_admin/addSCC');
const getAllSchema = require('../../models/shared/getAllSchema');
const getSCCByIDSchema = require('../../models/super_admin/getSCCByIDSchema');
const changeSCCStatusSchema = require('../../models/super_admin/changeSCCStatusSchema');
const updateSCCSchema = require('../../models/super_admin/updateSCCSchema');
const ddgetProvinceByRegionIDSchema = require('../../models/super_admin/ddgetProvinceByRegionIDSchema');
const getAllUserByRegIDAndprovIDSchema = require('../../models/super_admin/getAllUserByRegIDAndprovIDSchema');


router.route('/scc')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addSCCSchema}), (req,res) => {
    addSCC(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllSchema}), (req,res) => {
    getAllSCC(req,res)
})

router.route('/scc/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getSCCByIDSchema}), (req,res) => {
    getSCCByID(req,res)
})
.patch(passport.authenticate('jwt', {session : false}),validator.validate({params: getSCCByIDSchema, body: changeSCCStatusSchema}), (req,res) => {
    changeSCCStatus(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getSCCByIDSchema, body: updateSCCSchema}), (req,res) => {
    updateSCCByID(req,res)
})

router.route('/dd/province/:rid')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: ddgetProvinceByRegionIDSchema}), (req,res) => {
    ddgetAllProvinceByRegion(req,res)
})

router.route('/users/scc/:regionID/:provID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getAllUserByRegIDAndprovIDSchema}), (req,res) => {
    allUsersByRegIDandprovID(req,res)
})
module.exports = router;