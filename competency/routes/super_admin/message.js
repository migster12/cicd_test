const express = require('express');
const router = express.Router();
const validator = require('../../middleware/validator');
const passport = require('../../config/authToken');

// -------- Functions ---------------
const addMessage = require("../../controller/super_admin/system_management/messages/addMessage");
const getAllMessage = require("../../controller/super_admin/system_management/messages/getAllMessage");
const getMessageByID = require("../../controller/super_admin/system_management/messages/getMessageByID");
const updateMessageByID = require("../../controller/super_admin/system_management/messages/updateMessageByID");
const disableMessage = require("../../controller/super_admin/system_management/messages/disableMessage");
const enableMessage = require("../../controller/super_admin/system_management/messages/enableMessage");

// -------- Models ---------------
const getAllSchema = require('../../models/shared/getAllSchema');
const getByIDSchema = require('../../models/shared/getByIDSchema');
const addMessageSchema = require('../../models/super_admin/addMessage');


router.route('/message')
.post(passport.authenticate('jwt', {session : false}),validator.validate({body: addMessageSchema}), (req,res) => {
    addMessage(req,res)
})
.get(passport.authenticate('jwt', {session : false}),validator.validate({query: getAllSchema}), (req,res) => {
    getAllMessage(req,res)
})

router.route('/message/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    getMessageByID(req,res)
})
.put(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema, body: addMessageSchema}), (req,res) => {
    updateMessageByID(req,res)
})

router.route('/disable/message/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    disableMessage(req,res)
})
router.route('/enable/message/:id')
.get(passport.authenticate('jwt', {session : false}),validator.validate({params: getByIDSchema}), (req,res) => {
    enableMessage(req,res)
})

module.exports = router;