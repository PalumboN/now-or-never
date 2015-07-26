'use strict'

window.app = angular.module 'now-or-never-app', [
  'ui.router'
  'ui.bootstrap'
  'btford.socket-io'
  'ngCookies'
]

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  partials = (view) -> "partials/" + view

  $stateProvider
  .state('home',
    url: '/'
    templateUrl: partials 'home'
  )

  $stateProvider
  .state('login',
    url: '/login'
    templateUrl: partials 'login'
  )

  $stateProvider
  .state('chat',
    url: '/chat/:nick'
    templateUrl: partials 'chat'
    controller: 'ChatCtrl'
  )
