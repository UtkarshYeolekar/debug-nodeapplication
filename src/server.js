    const express = require('express'),
        app = express();
  
    console.log("Starting server...");
  
    app.get('/', function (req, res) {
      res.send('Hello From Server!')
    });
  
    app.get('/crash', function (req, res) {
      res.send('Crashing the container!');
      process.nextTick(function () {
        throw new Error("CRASH!");
      });
    });
  
    app.listen(3000, function () {
      console.log('Example Server listening on port 3000!');
    });