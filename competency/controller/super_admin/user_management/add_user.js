const env = require('../../../config/db.config');
const sql = require('mysql');
const debug = require('../../../config/debug')
const generator = require('generate-password');
const nodemailer = require('nodemailer');
require('dotenv').config();




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
const json_f = { "results": "FAILED", "message": "Something went wrong! Please try again"}
const json_s = { "results": "SUCCESS", "message": "Successfully Created User"}
const json_exist = { "results": "SUCCESS", "message": "User already exist"}
const handler = async (event,callback) => {
    debug && console.log("Super Admin Add User Handler")
    const { username, name, email, region_id, user_type, education, mobile_number,
            division_id, position, sex, date_of_birth, province_or_huc_id, place_of_birth,
            address, municipality_id, scc_id, remarks }= event.body;
    const created_by = event.user.username
    try{
        const password = await generatePassword()
        debug && console.log(password)
        bcrypt.hash(password,saltRounds,(err, hashedPassword)=> {
            if(err) return callback.send(err);
        
                const query = `call SuperAdmin_AddUser( '${username}', '${hashedPassword}', '${name}', '${email}', '${region_id}','${user_type}', "${education}", '${mobile_number}', '${division_id}', "${position}", '${sex}', '${date_of_birth}', "${province_or_huc_id}", "${place_of_birth}", '${address}', '${municipality_id}', '${scc_id}', '${remarks}', '${created_by}')`; 
                debug && console.log(query);
                pool.getConnection((err,connection) => {
                    if(err) {
                        debug && console.log(err);
                        callback.status(200).send(json_f);
                        return
                    }
                    connection.query(query, (error,results) => {
                        // connection.release();
                        if(error) {
                            debug && console.log(error);
                            callback.status(400).send(json_f);
                            return
                        }
                        else if(results == '') {
                            debug && console.log('Record is empty or undefined.')
                            callback.status(200).send(json_f);
                            return
                        }
                        else if(results.affectedRows == 0) {
                            debug && console.log('User already exist.')
                            callback.status(200).send(json_exist)
                            return
                        }
                        else {
                            emailData = { "email": email, "name": name, "username": username, "password": password}
                            sendEmail(emailData)

                            let updateQuery = "";
                            if (user_type === 'regional admin') {
                                updateQuery = `CALL SuperAdmin_UpdateRegionAdmin('${region_id}', '${name}', '${created_by}')`;
                            } else if (user_type === 'provincial director' || user_type === 'city director') {
                                updateQuery = `CALL SuperAdmin_UpdateProvincialDirector('${province_or_huc_id}', '${name}', '${created_by}')`;
                            } else if (user_type === 'div chief') {
                                updateQuery = `CALL SuperAdmin_UpdateDivisionChief('${division_id}', '${name}', '${created_by}')`;
                            } else if (user_type === 'cluster head') {
                                updateQuery = `CALL SuperAdmin_UpdateClusterHead('${scc_id}', '${name}', '${created_by}')`;
                            }
                            debug && console.log("Update Query:", updateQuery);
                            if (updateQuery) {
                                connection.query(updateQuery, (updateError, updateResults) => {
                                    connection.release();
                                    if (updateError) {
                                        debug && console.log("Update Error:", updateError);
                                        callback.status(200).send(json_f);
                                        return
                                    } else {
                                        debug && console.log("User and related role updated successfully.", updateResults);
                                        callback.status(200).send(json_s);
                                        return
                                    }
                                });
                            } else {
                                connection.release();
                                callback.status(200).send(json_s);
                                return
                            }
                            // callback.status(200).send(json_s)
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

const generatePassword = () => {
    var password = generator.generate({
        length: 8,
        numbers: true,
        strict: true
    });
    debug && console.log(password);
    return password
}

const sendEmail = (data) => {
    let loginLink = process.env.LOGIN_LINK
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL,
            pass: process.env.EMAIL_PASSWORD
          }
    });

    const mailOptions = {
        from: process.env.EMAIL,
        to: data.email,
        subject: 'Initial Interview',
        html: `
            <h2>Initial Interview</h2>
            <p>Hi ${data.name},</p>
            <p>Job Offer from sitesphil</p>
            <p>Your account has been created successfully. Below are your account details:</p>
            <ul>
                <li><strong>Username:</strong> ${data.username}</li>
                <li><strong>Temporary Password:</strong> ${data.password}</li>
            </ul>
            <p>Please note that this is a temporary password. You are required to change it upon your first login.</p>
            <p>Click the link below to log in:</p>
            <p><a href="${loginLink}">${loginLink}</a></p>
            <p>If you have any questions, feel free to contact our support team.</p>`
      };
      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          debug && console.error(error);
        //   callback.status(500).json({ message: 'Failed to send password reset email' });
            return
        } else {
        //   callback.status(200).json({ message: 'Password reset email sent' });
            return
        }
      });
      return 
}


module.exports = handler;