#!/usr/bin/env nodejs

var sqlite3 = require('sqlite3').verbose();
var bodyParser = require('body-parser')
var restify = require('restify');
var util = require('util')

var db = new sqlite3.Database('default.sqlite');

var server = restify.createServer();
server.use(bodyParser.json())

createDb();

function createDb() {
  db.serialize(function() {
  db.run("CREATE TABLE IF NOT EXISTS sensorValues (timestamp INT, sensorId TEXT, sensorName TEXT, value REAL)");

  });
}

function saveSensorData(sensorData) {
  var timestamp = Math.floor(Date.now() / 1000);
  var stmt = db.prepare("INSERT INTO sensorValues VALUES (?, ?, ?, ?)");

  var nrSensors = sensorData.sensors.length;
  for (var i = 0; i < nrSensors; i++) {
    stmt.run(timestamp,sensorData.sensorId, sensorData.sensors[i].name, sensorData.sensors[i].value);
  }
  stmt.finalize();
}

function getSensorList(callback){
  db.all("SELECT DISTINCT sensorId, sensorName FROM sensorValues WHERE 1 ORDER BY sensorId ASC;", function(err, rows) {
    callback(rows)
  })
}

function getAllSensorData(sensorId, callback){
  db.all("SELECT timestamp, sensorName, value FROM sensorValues WHERE sensorId = ? ORDER BY sensorName ASC, timestamp DESC;",[sensorId], function(err, rows) {
    callback(rows)
  })
}

function getSensorData(sensorId, sensorName, callback){
  db.all("SELECT timestamp, value FROM sensorValues WHERE sensorId = ? AND sensorName = ? ORDER BY timestamp DESC;",[sensorId, sensorName], function(err, rows) {
    callback(rows)
  })
}

server.get('/sensors/:sensorId/:sensorName', function(req, res, next) {
  getSensorData(req.params.sensorId, req.params.sensorName, function(rows) {
    res.send(rows)
  })
});

server.get('/sensors/:sensorId', function(req, res, next) {
  getAllSensorData(req.params.sensorId, function(rows) {
    res.send(rows)
  })
});

server.get('/sensors', function (req, res, next) {
  getSensorList( function(rows) {
    res.send(rows)
  })
});


server.post('/log', function (req, res, next) {
  console.log("Got data:\n" + util.inspect(req.body, false, null))
  saveSensorData(req.body)
  res.send(req.body);
});

server.get('/', function(req, res, next) {
    res.send('hello world');
});

server.listen(3000, function() {
    console.log('Listening on port 3000');
});
