'use strict'

class ChatCtrl extends BaseCtrl
  @register()

  initialize: =>
    @s.messages = ["Hola", "Puto", "Trolo"]
    @s.nick = @$stateParams.nick