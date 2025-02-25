const sql = require('mysql');
const env = require('../../../../config/db.config')
const debug = require('../../../../config/debug')

const json_s = {"result":"SUCCESS","message":"Status Changed!"};
const json_f = {"result":"FAILED","message":"An error occur, please retry"};
const json_exist = {"result":"SUCCESS","message":"The division does not exist"};


const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    password: env.password,
    database: env.db
});

const handler = (event, callback) => {
    debug && console.log("Active Inactive Municipality Handler")

    const rStatus = event.body.status
    const muniID = event.params.mID

    const query = `call SuperAdmin_ChangeMunicipalityStatus(${muniID}, '${rStatus}')`
    try {
        pool.getConnection((error, connection) => {
            if(error){
                debug && console.log(error);
                callback.status(200).send(json_f);
                return
            }
            connection.query(query, (err, res)=>{
                connection.release()
                if(err){
                    debug && console.log(err)
                    callback.status(200).send(json_f)
                    return
                }
                else if(res.affectedRows == 0) {
                    debug && console.log("Not Exist")
                    callback.status(200).send(json_exist);
                }
                else {
                    callback.status(200).send(json_s)
                }
            })
        }) 
    }
    catch(error){
        debug && console.log("Error: ", error)
        return callback.status(200).send(json_f)
    }
}
module.exports = handler;