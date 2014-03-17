// Include http module, 
var http = require('http'), 
// And mysql module you've just installed. 
    mysql = require("mysql"); 
      
// Create the connection. 
// Data is default to new mysql installation and should be changed according to your configuration. 
var connection = mysql.createConnection({ 
    user: "klutz", 
    password: "cabbages", 
    database: "SNIPT"
}); 

connection.query('SELECT * FROM SNIPT.ppi;', function(error, rows, fields))