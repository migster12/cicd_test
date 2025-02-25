const env = require('../../../config/db.config');
const sql = require('mysql');
const debug = require('../../../config/debug')

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
json_s = { "results": "SUCCESS", "message": "Successfully Register"}
const handler = (event,callback) => {
    debug && console.log("Super Admin Register Handler")
    const {username, password }= event.body;
    try{
        bcrypt.hash(password,saltRounds,(err, hashedPassword)=> {
            if(err) return callback.send(err);
        
                const query = `call SuperAdmin_Register('${username}', '${hashedPassword}')`; 
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
                            debug && console.log('User already exist.', results)
                            debug && console.log('User already exist.')
                            callback.status(200).send(json_f)
                        }
                        else {
                            console.log(results)
                            callback.status(200).send(json_s)
                        }
                    });
                });
            }) 
    }
    catch(error){
        debug && console.log("Error: ", error)
        return callback.status(200).send(json_f);
    }
}

module.exports = handler;