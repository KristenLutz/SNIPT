
var mysql = require('mysql');
var express = require('express');
 
 
// Application initialization
var connection = mysql.createConnection({
        host     : '209.208.110.182',
        user     : 'klutz',
        password : 'cabbages',
        insecureAuth: true,
        database : 'SNIPT',
    });

var app = express.createServer();
app.use(express.bodyParser());
app.use(express.static( __dirname + '/static' ));



// Database setup
connection.connect();

app.get('/', function(req, res){
   var query = connection.query(
        'SELECT * FROM ppi',function(err, result) {
                if (err) throw err;
                res.jsonp(result);
        });     
});

//passes query into


//connection.end();
app.listen(3000);
