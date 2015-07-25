'use strict'

window.app = angular.module 'now-or-never-app', [
  'ngRoute'
  'ui.router'
  'ui.bootstrap'
]

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/login'

  $stateProvider
  .state('login',
    url: '/login'
    templateUrl: 'main.jade'
    controller: 'LoginCtrl'
  )
