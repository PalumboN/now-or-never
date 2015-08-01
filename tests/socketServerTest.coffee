exports.listen = (port) ->
  io = require('socket.io').listen(port)
  io.sockets