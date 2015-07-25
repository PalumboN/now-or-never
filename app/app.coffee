'use strict'

window.app = angular.module 'now-or-never-app', [
  'ui.router'
  'ui.bootstrap'
]

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  console.log "----------------------"

  $stateProvider
  .state('home',
    url: '/'
    templateUrl: 'partials/home'
  )

  $stateProvider
  .state('login',
    url: '/login'
    templateUrl: 'partials/login'
    controller: 'LoginCtrl'
  )
