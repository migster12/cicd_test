const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addMunicipality = require("../../controller/super_admin/system_management/municipality/addMunicipality");
const getAllMunicipality = require("../../controller/super_admin/system_management/municipality/getAllMunicipality");
const getMunicipalityByID = require("../../controller/super_admin/system_management/municipality/getMunicipalityByID");
const getAllClusterByRegionAndProvince = require("../../controller/super_admin/system_management/municipality/getAllClusterByRegionAndProvince");
const changeMunicipalityStatus = require("../../controller/super_admin/system_management/municipality/changeMunicipalityStatus");
const updateMunicipalityByID = require("../../controller/super_admin/system_management/municipality/updateMunicipalityByID");
const allUserByMuniID = require("../../controller/super_admin/system_management/municipality/allUserByMuniID");

// -------- Models ---------------
const addMunicipalitySchema = require('../../models/super_admin/addMunicipality');
const getAllSchema = require('../../models/shared/getAllSchema');
const getMunicipalityByIDSchema = require('../../models/super_admin/getMunicipalityByIDSchema');
const getClusterByRegIDandProvIDSchema = require('../../models/super_admin/getClusterByRegIDandProvID');
const changeMunicipalityStatusSchema = require('../../models/super_admin/changeMunicipalityStatusSchema');
const updateMunicipalitySchema = require('../../models/super_admin/updateMunicipalitySchema');
const getAllUserByRegionIDAndMuniIDSchema = require('../../models/super_admin/getAllUserByRegionIDAndMuniID');


router.route('/municipality')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addMunicipalitySchema}), (req,res) => {
    addMunicipality(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllSchema}), (req,res) => {
    getAllMunicipality(req,res)
})

router.route('/municipality/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getMunicipalityByIDSchema}), (req,res) => {
    getMunicipalityByID(req,res)
})
.patch(passport.authenticate('jwt', {session : false}),validator.validate({params: getMunicipalityByIDSchema, body: changeMunicipalityStatusSchema}), (req,res) => {
    changeMunicipalityStatus(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getMunicipalityByIDSchema, body: updateMunicipalitySchema}), (req,res) => {
    updateMunicipalityByID(req,res)
})


router.route('/cluster/municipality/:rid/:provID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getClusterByRegIDandProvIDSchema}), (req,res) => {
    getAllClusterByRegionAndProvince(req,res)
})

router.route('/users/by/municipality/:regionID/:municipalityID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getAllUserByRegionIDAndMuniIDSchema}), (req,res) => {
    allUserByMuniID(req,res)
})

module.exports = router;