
/**
 * Module dependencies.
 */

var express = require('express');
//var routes = require('./routes');
//var user = require('./routes/user');
var http = require('http');
var path = require('path');
var mysql = require('mysql');
var app = express();

// all environments
app.set('port', process.env.PORT || 80);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hjs');
app.use(express.favicon());
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.bodyParser());
app.use(require('less-middleware')(path.join(__dirname, '/public')));
app.use(express.static(path.join(__dirname, '/public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
  app.use(express.logger('dev'));
}
//mysql connection

var connection = mysql.createConnection({
        host     : '209.208.110.182',
        user     : 'klutz',
        password : 'cabbages',
        insecureAuth: true,
        database : 'SNIPT',
    });

connection.connect();

app.get('/', function(req, res){
   var query = connection.query(
        'SELECT * FROM proteinInteractions',function(err, result) {
                if (err) throw err;
                res.render('index', {
                          total: result,
                          ppi_id: result[0].ppi_id,
                          protein_A_id: result[0].proteinA,
                          protein_B_id: result[0].proteinB,
                          interaction: result[0].interaction_type_name,
                          link: result[0].link});
        });     
});


//!mysql

//app.get('/', routes.index);
//app.get('/users', user.list);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
