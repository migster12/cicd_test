const env = require('../../../config/db.config');
const sql = require('mysql');
const debug = require('../../../config/debug')

const json_f = {"result":"FAILED","message":"An error occur, please retry"};

const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    port: env.port,
    password: env.password,
    database: env.db
});
const handler = (event,callback) => {
    debug && console.log("Get Dashboard Handler")

    const query = `call SuperAdmin_Dashboard();`;
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
                    // const data = results || []
                    const activeUsers = results[0]?.[0]?.active_users_total ?? "";
                    const inactiveUsers = results[1]?.[0]?.inactive_users_total ?? "";
                    const raters = results[2]?.[0]?.raters_total ?? "";
                    const ratees = results[3]?.[0]?.ratees_total ?? "";
                    callback.status(200).send({"results": "SUCCESS", "message": 'Successfully retrieved data', "data": {activeUsers, inactiveUsers, raters, ratees}});
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