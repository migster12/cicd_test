const Validator = require('express-json-validator-middleware');

const { validate } = new Validator.Validator();

const errorHandler = (error, req, res,next) => {
    const json_f = { results: "FAILED", message: "Invalid Input"}
    if(error instanceof Validator.ValidationError) {
        // console.log("Validator Error: ", error)
        console.log("Validator Error: ", error.validationErrors)
        res.status(200).send(json_f);
        next();
    }
    else {
        res.status(200).send(json_f);
        next(error);
    }
}
module.exports = {
    validate : validate,
    errorHandler : errorHandler
}