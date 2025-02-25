const env = require('../../../config/db.config');
const sql = require('mysql');
const debug = require('../../../config/debug')
const generator = require('generate-password');


//for hashing passwords
const bcrypt = require('bcrypt');
const saltRounds = 12;

const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    password: env.password,
    database: env.db
});

// -------- custom json payload ---------
json_f = { "results": "FAILED", "message": "Something went wrong! Please try again"}
json_s = { "results": "SUCCESS", "message": "Successfully updated user details"}
json_exist = { "results": "SUCCESS", "message": "User does not exist."}
const handler = async (event,callback) => {
    debug && console.log("Super Admin Update User Handler")
    const uid = event.params.uid
    const { name, email, region_id, user_type, education, mobile_number,
            division_id, position, sex, date_of_birth, provice_or_huc_id, place_of_birth,
            address, municipality_id, scc_id, remarks }= event.body;
    try{
        const query = `call SuperAdmin_UpdateUser( ${uid},  '${name}', '${email}', '${region_id}','${user_type}', "${education}", '${mobile_number}', '${division_id}', '${position}', '${sex}', '${date_of_birth}', '${provice_or_huc_id}', '${place_of_birth}', '${address}', '${municipality_id}', '${scc_id}', '${remarks}')`; 
        pool.getConnection((err,connection) => {
            if(err) {
                debug && console.log(err);
                callback.status(200).send(json_f);
                return
            }
            connection.query(query, (error,results) => {
                connection.release();
                if(error) {
                    debug && console.log(error);
                    callback.status(400).send(json_f);
                    return
                }
                else if(results == '') {
                    debug && console.log('Record is empty or undefined.')
                    callback.status(200).send(json_f);
                }
                else if(results.affectedRows == 0) {
                    debug && console.log('User does not exist.')
                    callback.status(200).send(json_exist)
                }
                else {
                    callback.status(200).send(json_s)
                }
            });
        }); 
    }
    catch(error){
        debug && console.log("Error: ", error)
        return callback.status(200).send(json_f);
    }
}

module.exports = handler;