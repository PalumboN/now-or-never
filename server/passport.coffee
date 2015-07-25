require('require-dir')("./strategies")
passport = require('passport')
FacebookStrategy = require('passport-facebook').Strategy

passport.use new FacebookStrategy
    clientID: "984062531613818"
    clientSecret: "394008e2ad57e8deac45ca91d96afbfb"
    callbackURL: "http://localhost:3000/auth/facebook/callback"
    enableProof: false
  ,
  (accessToken, refreshToken, profile, done) ->
    laPosta = 
      accessToken: accessToken
      refreshToken: refreshToken
      profile: profile
    done null, laPosta

fakeSerialize = (user, done) -> done null, user
passport.serializeUser fakeSerialize
passport.deserializeUser fakeSerialize

module.exports= (app) ->
  app.use passport.initialize()
  app.use passport.session()

  app.get '/auth/facebook', passport.authenticate('facebook', scope: ['user_status', 'user_about_me'])

  app.get '/auth/facebook/callback', passport.authenticate('facebook', failureRedirect: '/'), (req, res) ->
    console.log req.user
    res.cookie "user", JSON.stringify req.user
    res.redirect('/')
