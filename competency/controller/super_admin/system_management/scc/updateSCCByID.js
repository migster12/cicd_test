const sql = require('mysql');
const env = require('../../../../config/db.config')
const debug = require('../../../../config/debug')

const json_s = {"result":"SUCCESS","message":"Successfully Updated!"};
const json_f = {"result":"FAILED","message":"An error occur, please retry"};
const json_exist = {"result":"SUCCESS","message":"The Section, Cluster, City does not exist"};


const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    password: env.password,
    database: env.db
});

const handler = (event, callback) => {
    debug && console.log("Update SCC Handler")
    
    const { scc_head, scc_name, username, type, region_id, province_or_city_id } = event.body
    const sccID = event.params.id

    const query = `call SuperAdmin_UpdateSCC(${sccID}, '${scc_name}', '${scc_head}', '${type}', ${region_id}, ${province_or_city_id}, '${username}')`
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
        debug && console.log("Error:", error)
        return callback.status(200).send(json_f)
    }
}
module.exports = handler;