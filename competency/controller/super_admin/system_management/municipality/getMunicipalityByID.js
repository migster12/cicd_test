const env = require('../../../../config/db.config');
const sql = require('mysql');
const debug = require('../../../../config/debug')

const json_f = {"result":"FAILED","message":"An error occur, please retry"};

const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    port: env.port,
    password: env.password,
    database: env.db
});
const handler = (event,callback) => {
    debug && console.log("Get Municipality By ID Handler")
    const mID = event.params.id;

    const query = `call SuperAdmin_GetMunicipalityByID(${mID});`;
    try{
        pool.getConnection((err,connection) => {
            if(err) {
                debug && console.log("Error: ", error)
                callback.status(200).send(json_f);
                return
            }
            connection.query(query, (error,results) => {
                connection.release();
                if(error) {
                    debug && console.log("Error: ", error)
                    callback.status(200).send(json_f);
                    return
                }
                else {
                    console.log(results)
                    const data = results[0] || []
                    callback.status(200).send({"results": "SUCCESS", "message": 'Successfully retrieved data', "data": data});
                }
            });
        });
    }
    catch(error){
        debug && console.log("Error: ", error)
        return callback.status(200).send(json_f)
    }
    
}

module.exports = handler;