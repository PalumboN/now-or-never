Queue = require('../queue')

exports.listen = (http) ->
  io = require('socket.io').listen(http)
  new Queue io.sockets
