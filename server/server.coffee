###*
# Module dependencies.
###
express = require('express')
passport = require('./passport')
routes = require('./routes')
user = require('./routes/user')
chat = require('./routes/chat_servidor')
http = require('http')
path = require('path')
_ = require('lodash')

app = express()


# all environments
app.set 'port', process.env.PORT or 3000
app.set 'views', path.join(__dirname, '../app/views')
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.static(path.join(__dirname, '../public'))

passport app

app.use app.router

# development only
if 'development' == app.get('env')
  app.use express.errorHandler()

app.get '/', (req, res) -> res.render "layout"
app.get '/partials/*', (req, res) -> res.render _.trimLeft req.url, '/'

app.get '/users', user.list
app.get '/chat', (req, res) -> res.render 'chat'

server = http.createServer(app).listen(app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  return
)

chat.iniciar server