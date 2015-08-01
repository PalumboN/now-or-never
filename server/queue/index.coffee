_ = require('lodash')

module.exports =
  class QueueManager

    constructor: (sockets) -> 
      @queue = []
      sockets.on 'connection', @newConnection

    newConnection: (socket) =>
      conectados = => 
        console.log "Conectados (" + @queue.length + "): " + (_.map @queue, 'nick')
      
      @queue.push socket
      conectados()

      socket.on 'searching', (nick) =>
        socket.nick = nick
        conectados()
        @searchMatch socket

      socket.on 'send_message', (message) =>
        socket.chatting.emit 'new_message', message

      socket.on 'disconnect', =>
        if socket.chatting?
          @_disconnect socket, socket.chatting
        _.pull @queue, socket
        conectados()

    searchMatch: (socket) =>
      otherSocket = _.find @queue, (it) -> it isnt socket and it.nick? and not it.chatting?
      if otherSocket?
        console.log "Match: " + otherSocket.nick + " & " + socket.nick
        @_connect socket, otherSocket 

    _connect: (socket, otherSocket) =>
      socket.chatting = otherSocket
      socket.emit 'find', otherSocket.nick
      otherSocket.chatting = socket
      otherSocket.emit 'find', socket.nick

    _disconnect: (socket, otherSocket) =>
      delete socket.chatting
      socket.emit 'lost_user', otherSocket.nick
      delete otherSocket.chatting
      otherSocket.emit 'lost_user', socket.nick
