module.exports = function (grunt) {

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);


  // Define the configuration for all the tasks
  grunt.initConfig({

    yeoman: {
      app: 'app',
      server: 'server',
      views: 'views',
      main: 'main.js'
    },

    express: {
      options: {
        port: process.env.PORT || 3000
      },
      dev: {
        options: {
          script: '<%= yeoman.main %>',
          debug: true
        }
      },
      prod: {
        options: {
          script: '<%= yeoman.main %>',
          node_env: 'production',
        }
      }
    },

    open: {
      server: {
        url: 'http://localhost:<%= express.options.port %>'
      }
    },

    watch: {
      coffeeServer: {
        files: ['<%= yeoman.server %>/**/*.coffee']
      },

      livereload: {
        files: [
          '<%= yeoman.app %>/<%= yeoman.views %>/**/*.{html,jade}',
          '<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}'
        ],
        options: {
          livereload: true
        }
      },

      gruntfile: {
        files: ['Gruntfile.js']
      },

      express: {
        files: [
          '<%= yeoman.main %>',
          'lib/**/*.{js,json}'
        ],
        tasks: ['express:dev'],
        options: {
          livereload: true,
          nospawn: true //Without this option specified express won't be reloaded
        }
      }
    }
  });

  grunt.registerTask('serve', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'express:prod', 'open', 'express-keepalive']);
    }

    grunt.task.run([
      'express:dev',
      'open',
      'watch'
    ]);
  });

}