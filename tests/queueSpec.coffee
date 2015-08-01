should = require('should')
_ = require('lodash')
io = require('socket.io-client')
socketServer = require('./socketServerTest').listen 5000
Queue = require('../server/queue')

queue = null
clients = null

newClient = -> io.connect('http://localhost:5000', forceNew: true)

describe "Chat Server", ->
  beforeEach ->
    queue = new Queue socketServer
    
  afterEach ->
    clients.forEach (it) -> it.disconnect()

  it 'should add to queue when connect', (done) ->
    queue.queue.length.should.be.exactly 0
    client = newClient()
    clients = [client]

    client.on "connect", ->
      queue.queue.length.should.be.exactly 1
      done()

  it "should answer nothing when only one client is searching", (done) ->
    client = newClient()
    otherClient = newClient()
    clients = [client, otherClient]

    client.on 'new_message', -> done("new_message")
    client.on 'find', -> done("find")
    client.on 'lost_user', -> done("lost_user")

    client.emit "searching", ""

    this.timeout 3000
    setTimeout((-> done()), 2000)

  it "should match itself when two clients are searching", (done) ->
    oneClient = newClient()
    otherClient = newClient()
    clients = [oneClient, otherClient]

    check = (client) ->
      client.checked = true
      done() if _.every clients, 'checked'

    oneClient.on "find", (nick) -> 
      nick.should.be.exactly "other"
      check oneClient

    otherClient.on "find", (nick) -> 
      nick.should.be.exactly "one"
      check otherClient

    oneClient.emit "searching", "one"
    otherClient.emit "searching", "other"

  it "should notify when chatting client is disconnected", (done) ->
    oneClient = newClient()
    otherClient = newClient()
    clients = [oneClient, otherClient]

    oneClient.on "find", (nick) -> 
      oneClient.disconnect()

    otherClient.on "lost_user", (nick) -> 
      nick.should.be.exactly "one"
      done()

    oneClient.emit "searching", "one"
    otherClient.emit "searching", "other"

  xit "should send messages between chatting clients", (done) ->
    oneClient = newClient()
    otherClient = newClient()
    clients = [oneClient, otherClient]

    oneMessage = "One message"
    otherMessage = "Other message"

    check = (client) ->
      client.checked = true
      done() if _.every clients, 'checked'

    oneClient.on "find", (nick) -> 
      oneClient.emit "send_message", oneMessage
    otherClient.on "find", (nick) -> 
      otherClient.emit "send_message", otherClient

    oneClient.on "new_message", (message) -> 
      message.should.be.exactly otherMessage
      check oneClient
    otherClient.on "new_message", (message) -> 
      message.should.be.exactly otherMessage
      check otherClient

    oneClient.emit "searching", "one"
    otherClient.emit "searching", "other"


  it "should not match matched clients", (done) ->
    client = newClient()
    oneClient = newClient()
    otherClient = newClient()
    clients = [client, oneClient, otherClient]

    matched = []

    found = (nick) ->
      console.log "NUIK " + nick
      matched.push nick
      done() if _.every ["one", "real"], (it) -> _.includes matched, it 

    oneClient.on "find", -> 
      client.emit "searching", "real"
      oneClient.disconnect()
    otherClient.on "lost_user", -> 
      otherClient.emit "searching", "other"
    otherClient.on "find", (nick) -> 
      found nick

    oneClient.emit "searching", "one"
    otherClient.emit "searching", "other"

    this.timeout 3000

