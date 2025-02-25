const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addProvince = require("../../controller/super_admin/system_management/province/addProvice");
const getAllProvince = require("../../controller/super_admin/system_management/province/getAllProvince");
const getProvinceByID = require("../../controller/super_admin/system_management/province/getProvinceByID");
const changeProvinceStatus = require("../../controller/super_admin/system_management/province/changeProvinceStatus");
const updateProvinceByID = require("../../controller/super_admin/system_management/province/updateProvinceByID");
const allUsersByRegIDandprovID = require("../../controller/super_admin/system_management/province/allUsersByRegIDandprovID");

// -------- Models ---------------
const addProvinceSchema = require('../../models/super_admin/addProvince');
const getAllSchema = require('../../models/shared/getAllSchema');
const getProvinceByIDSchema = require('../../models/super_admin/getProvinceByIDSchema');
const changeProvinceStatusSchema = require('../../models/super_admin/changeProvinceStatusSchema');
const updateProvinceSchema = require('../../models/super_admin/updateProvinceSchema');
const getAllUserByRegIDAndprovIDSchema = require('../../models/super_admin/getAllUserByRegIDAndprovIDSchema');


router.route('/province')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addProvinceSchema}), (req,res) => {
    addProvince(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllSchema}), (req,res) => {
    getAllProvince(req,res)
})

router.route('/province/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getProvinceByIDSchema}), (req,res) => {
    getProvinceByID(req,res)
})
.patch(passport.authenticate('jwt', {session : false}),validator.validate({params: getProvinceByIDSchema, body: changeProvinceStatusSchema}), (req,res) => {
    changeProvinceStatus(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getProvinceByIDSchema, body: updateProvinceSchema}), (req,res) => {
    updateProvinceByID(req,res)
})

router.route('/users/province/:regionID/:provID')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getAllUserByRegIDAndprovIDSchema}), (req,res) => {
    allUsersByRegIDandprovID(req,res)
})

module.exports = router;