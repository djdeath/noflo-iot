
var http = require('http');
var runtime = require('noflo-runtime-websocket');

var baseDir = '/noflo-iot';
var host = 'localhost';
var port = 5555;
var interval = 10 * 60 * 1000;

var server = http.createServer(function () {});
var rt = runtime(server, {
  baseDir: baseDir,
  captureOutput: false,
  catchExceptions: true
});

var NoFlo = require('noflo-iot');
var loader = new NoFlo.ComponentLoader('/noflo-iot');
console.log('listing components');
loader.listComponents(function(components) {
    console.log(components);
});

server.listen(port, function () {
  console.log('NoFlo runtime listening at ws://' + host + ':' + port);
  console.log('Using ' + baseDir + ' for component loading');
});
