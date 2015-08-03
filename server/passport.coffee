require('require-dir')("./strategies")
passport = require('passport')

fakeSerialize = (user, done) -> done null, user
passport.serializeUser fakeSerialize
passport.deserializeUser fakeSerialize

module.exports= (app) ->
  app.use passport.initialize()
  app.use passport.session()

  app.get '/auth/facebook', passport.authenticate('facebook', scope: ['user_status', 'user_about_me'])

  app.get '/auth/facebook/callback', passport.authenticate('facebook', failureRedirect: '/'), (req, res) ->
    console.log req.user
    req.user.profile.picture = "https://graph.facebook.com/v2.2/me/picture?access_token=" + req.user.accessToken
    res.locals.user = req.user
    res.render "login", req.user
