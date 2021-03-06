###*
# Module dependencies.
###
express = require('express')
passport = require('./passport')
routes = require('./routes')
user = require('./routes/user')
socketServer = require('./sockets')
http = require('http')
path = require('path')
_ = require('lodash')

app = express()


# all environments
app.set 'port', process.env.PORT or 3000
app.set 'views', path.join(__dirname, './views')
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.static(path.join(__dirname, './views'))

passport app

app.use app.router

# development only
if 'development' == app.get('env')
  app.use express.errorHandler()

# CORS (Cross-Origin Resource Sharing) headers to support Cross-site HTTP requests
app.all '*', (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  next()



#app.get '/', (req, res) -> res.render "layout"
app.get '/partials/*', (req, res) -> res.render _.trimLeft req.url, '/'

app.get '/users', user.list
#app.get '/chat', (req, res) -> res.render 'chat'

server = http.createServer(app).listen(app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  return
)

socketServer.listen server
