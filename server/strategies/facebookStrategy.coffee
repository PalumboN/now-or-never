passport = require('passport')
FacebookStrategy = require('passport-facebook').Strategy

passport.use new FacebookStrategy
    clientID: "984062531613818"
    clientSecret: "394008e2ad57e8deac45ca91d96afbfb"
    callbackURL: "http://now-or-never-server.herokuapp.com/auth/facebook/callback"
    enableProof: false
  ,
  (accessToken, refreshToken, profile, done) ->
    laPosta = 
      accessToken: accessToken
      refreshToken: refreshToken
      profile: profile
    done null, laPosta
