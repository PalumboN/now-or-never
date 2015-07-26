'use strict'

class ChatCtrl extends BaseCtrl
  @register "socketFactory", "$cookieStore"

  initialize: ->
    @s.messages = []
    @s.nick = @$cookieStore.get("user")?.profile.displayName || @$stateParams.nick

    @_connectSocket()

  send: (text) ->
    return if _.isEmpty text
    message = 
      user: @s.nick
      text: text
    @socket.emit 'message', message 
    @s.messages.push message
    @s.text = ""

  _connectSocket: ->
    @socket = @socketFactory ioSocket: io.connect('http://localhost:3000')

    @socket.on 'message', (message) => @s.messages.push message
    @socket.on 'match_founded', (userNick) => 
      @s.messages.push text: "Connected with " + userNick

    @socket.emit 'nick', @s.nick
