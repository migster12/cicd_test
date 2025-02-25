const express = require('express')
const PORT = 4400
const cors = require('cors')
require('dotenv').config();


const app = express()

var corsOptions = {
    // origin: ["http://192.168.1.162:4300", "http://192.168.1.162:4300/", "http://188.166.248.152:4300", "http://188.166.248.152:4300/", "http://188.166.248.152"]
    origin: "*"
};
  
app.use(cors(corsOptions))

app.use(express.json());
app.use(express.urlencoded({extended: false}));

const validator = require('./middleware/validator');


const routerSuperAdmin = require('./routes/super_admin/super_admin');
app.use(routerSuperAdmin);

app.use((req,res) => {
    res.status(404).send('Page Not Found');
})
app.use(validator.errorHandler);

app.listen(PORT, () => {
    console.log(`Server is running on Port: ${PORT}`);
});

