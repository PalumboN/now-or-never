_ = require('lodash')

module.exports =
  class QueueManager

    constructor: (sockets) -> 
      @queue = []
      sockets.on 'connection', @newConnection

    newConnection: (socket) =>
      console.log "Connected"
      @queue.push socket
      socket.on 'nick', (nick) =>
        socket.nick = nick
        console.log "Conectados: " + (_.map @queue, 'nick')
        @searchMatch socket

      socket.on 'disconnect', =>
        @queue.pop socket
        console.log "Conectados: " + (_.map @queue, 'nick')


    searchMatch: (socket) =>
      otherSocket = _.find @queue, (it) -> it isnt socket && it.nick?
      if otherSocket?
        console.log "Match"
        socket.emit 'match_founded', otherSocket.nick
        otherSocket.emit 'match_founded', socket.nick
