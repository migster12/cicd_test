const env = require('../../../config/db.config');
const sql = require('mysql');
//for signing tokens
const jwt = require('jsonwebtoken');
const debug = require('../../../config/debug')

//for hashing passwords
const bcrypt = require('bcrypt');

const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    password: env.password,
    database: env.db
});;

// -------- custom json payload ---------
json_f = { "results": "FAILED", "message": "Something went wrong! Please try again"}
json_invalid_creds = { "results": "INVALID", "message": "Invalid Credentials"}
// json_s = { "results": "SUCCESS", "message": "Successfully Register"}
const { S_ADMIN_LOGIN_LINK } = process.env
const handler = (event,callback) => {
    debug && console.log('Super Admin Login handler')
    
    const {username, password} = event.body;

    const query = `call SuperAdmin_Login('${username}');`;
    try {
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
                    callback.status(200).send(json_f);
                }
                else if(results == '') {
                    console.log("Empty")
                    callback.status(200).send(json_invalid_creds);
                }
                else if(results[0].length < 1) {
                    callback.status(200).send(json_invalid_creds);
                }
                else {
                    console.log(results)
                    let hashedPassword = results[0][0].password;
                    let username = results[0][0].username
                    bcrypt.compare(password, hashedPassword, (err, result) => {
                        if(err) return callback.send(err);
                        else if(result == true){
                            console.log(S_ADMIN_LOGIN_LINK)
                            let token = generateAccessToken({username: username});
                            return callback.status(200).send({ result: "SUCCESS", message: 'Successfully logged in.', token: token, username: username, redirect_url: S_ADMIN_LOGIN_LINK});
                        }
                        else{callback.status(200).send({message: 'Invalid Credentials'});}
                    })
                }
            });
        });
    }
    catch(error){
        debug && console.log("Error: ", error)
        return callback.status(200).send(json_f);
    }
}

const generateAccessToken = (empID) => {
    return jwt.sign(empID, 'mysecret', {expiresIn:10800});
}

module.exports = handler;