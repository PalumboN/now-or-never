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
    @socket.emit 'send_message', message 
    @s.messages.push message
    @s.text = ""

  _connectSocket: ->
    @socket = @socketFactory ioSocket: io.connect('http://localhost:3000', forceNew: true)

    @socket.on 'new_message', (message) => 
      @s.messages.push message
    @socket.on 'find', (userNick) => 
      @s.messages.push text: "Connected with " + userNick
    @socket.on 'lost_user', =>
      @s.messages.push text: "Searching..."
      @socket.emit 'searching', @s.nick

    @s.messages.push text: "Searching..."
    @socket.emit 'searching', @s.nick
