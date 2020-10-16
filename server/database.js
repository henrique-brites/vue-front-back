const poolConfig = {
    host     : `${process.env.DBHOST}`,
    user     : `${process.env.DBUSER}`,
    password : `${process.env.DBPASSWORD}`,
    database : `${process.env.DBNAME}`,
    debug    :  false,
    waitForConnections: true,
    connectionLimit: 30,
    queueLimit: 0
 };

const mysqlp = require('mysql2/promise');

module.exports = mysqlp.createPool(poolConfig);