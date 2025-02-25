const sql = require('mysql');
const env = require('../../../../config/db.config')
const debug = require('../../../../config/debug')

const json_s = {"result":"SUCCESS","message":"Successfully Added!"};
const json_f = {"result":"FAILED","message":"An error occur, please retry"};
const json_exist = {"result":"SUCCESS","message":"Message already exist"};


const pool = sql.createPool({
    host: env.hostname,
    user: env.user,
    password: env.password,
    database: env.db
});

const handler = (event, callback) => {
    debug && console.log("Add Message Handler")

    const { message } = event.body
    const created_by = event.user.username

    const query = `call SuperAdmin_AddMessage('${message}', '${created_by}')`
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
                    debug && console.log("Already Exist")
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