class @BaseCtrl
    @register: (args...)->
        name = @name || @toString().match(/function\s*(.*?)\(/)?[1]
        @inject.apply @, args
        app.controller name, @
        name

    @inject: (args...) ->
        @$inject = _(@$inject)
            .union(args,['$scope'])
            .uniq()
            .value()

    constructor: (args...) ->
        for key, index in @constructor.$inject
            @[key] = args[index]

        @s = @$scope

        for key, index in @constructor.$inject
            @s[key] = args[index]

        for key, fn of @constructor.prototype
            continue unless typeof fn is 'function'
            continue if key in ['constructor', 'initialize'] or key[0] is '_'
            @s[key] = fn.bind?(@)

        @initialize?()
