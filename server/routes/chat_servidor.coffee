nicks = new Array

usuarios = (socket) ->
  socket.emit 'usuarios', nicks: nicks
  socket.broadcast.emit 'usuarios', nicks: nicks
  return

nuevoUsuario = (socket) ->
  socket.on 'nick', (data) ->
    nick = data.nick
    if nicks.indexOf(nick) == -1
      nicks.push nick
      socket.nick = nick
      socket.emit 'nick',
        correcto: true
        nick: nick
      socket.broadcast.emit 'nuevo_usuario', nick: nick
      usuarios socket
    else
      socket.emit 'nick',
        correcto: false
        nick: nick

enviarMsj = (socket) ->
  socket.on 'mensaje', (data) ->
    console.log data
    socket.broadcast.emit 'mensaje', data

usuario_desconectado = (socket) ->
  socket.on 'disconnect', ->
    if socket.nick
      nicks.splice nicks.indexOf(socket.nick), 1
      socket.broadcast.emit 'disconnect', nick: socket.nick
      usuarios socket

exports.iniciar = (http) ->
  io = require('socket.io').listen(http)
  io.sockets.on 'connection', (socket) ->
    console.log "Conectado"
    usuarios socket
    nuevoUsuario socket
    enviarMsj socket
    usuario_desconectado socket
