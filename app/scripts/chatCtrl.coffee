'use strict'

class ChatCtrl extends BaseCtrl
  @register "socketFactory", "$cookieStore"

  initialize: ->
    @s.messages = []
    @s.nick = @$cookieStore.get("user").profile.displayName

    @_connectSocket()

  send: (text) ->
    return if _.isEmpty text
    message = 
      user: @s.nick
      text: text
    @socket.emit 'mensaje', message 
    @s.messages.push message
    @s.text = ""

  _connectSocket: ->
    @socket = @socketFactory ioSocket: io.connect('http://localhost:3000')

    @socket.on 'mensaje', (message) => @s.messages.push message