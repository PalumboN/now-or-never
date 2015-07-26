module.exports = function (grunt) {

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);


  // Define the configuration for all the tasks
  grunt.initConfig({

    yeoman: {
      app: 'app',
      server: 'server',
      views: 'views',
      root: 'public',
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

    // Open browser
    open: {
      server: {
        url: 'http://localhost:<%= express.options.port %>'
      }
    },

    // Compiles CoffeeScript to JavaScript
    coffee: {
      server: {
        files: [
          {
            expand: true,
            cwd: "<%= yeoman.app %>",
            src: ["**/*.coffee", "!**/*.spec.coffee"],
            dest: "<%= yeoman.root %>",
            ext: ".js"
          }
        ]
      }
    },


    injector: {
      // Inject application script files into main.html (doesn't include bower)
      scripts: {
        options: {
          transform: function(filePath) {
            filePath = filePath.replace("/public/", "");
            return "script(src=\"" + filePath + "\")";
          },
          starttag: "// injector:js",
          endtag: "// endinjector"
        },
        files: {
          "<%= yeoman.app %>/<%= yeoman.views %>/layout.jade": [
            "<%= yeoman.root %>/**/*.js", 
            "!<%= yeoman.root %>/app.js", // hardcoded for first
            "!<%= yeoman.root %>/bower_components/**/*.js", 
            "!<%= yeoman.root %>/**/*.spec.js", 
            "!<%= yeoman.root %>/**/*.mock.js"
          ]
        }
      },

      // Inject component scss into app.scss
      sass: {
        options: {
          transform: function(filePath) {
            //filePath = filePath.replace("/client/app/", "");
            return "@import '" + filePath + "';";
          },
          starttag: "// injector",
          endtag: "// endinjector"
        },
        files: {
          "<%= yeoman.app %>/styles/main.scss": [
            "<%= yeoman.app %>/**/!(_)*.{scss,sass}", 
            "!<%= yeoman.app %>/styles/main.{scss,sass}"
          ]
        }
      },

      // Inject component css into main.html
      css: {
        options: {
          transform: function(filePath) {
            filePath = filePath.replace("/app/", "");
            return "link(rel=\"stylesheet\" href=\"" + filePath + "\")";
          },
          starttag: "// injector:css",
          endtag: "// endinjector"
        },
        files: {
          "<%= yeoman.app %>/<%= yeoman.views %>/layout.jade": ["<%= yeoman.app %>/**/*.css"]
        }
      }
    },

    // Watch for changes
    watch: {
      coffee: {
        files: [
        '<%= yeoman.app %>/**/*.coffee'
        ],
        tasks: [
          "coffee",
          "injector:scripts"
        ]
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
          '<%= yeoman.server %>/**/*.coffee',
          '<%= yeoman.main %>',
          'lib/**/*.{js,json}'
        ],
        tasks: ['express:dev'],
        options: {
          livereload: true,
          nospawn: true //Without this option specified express won't be reloaded
        }
      }
    },

    // Automatically inject Bower components into the app
    wiredep: {
      target: {
        src: "<%= yeoman.app %>/<%= yeoman.views %>/layout.jade",
        ignorePath: "../../public/",
        exclude: []
      }
    },

    copy: {
      styles: {
        expand: true,
        cwd: '<%= yeoman.app %>/styles',
        dest: 'public/styles/',
        src: '{,*/}*.css'
      }
    }

  });

  grunt.registerTask('prod', function (target) {
    grunt.task.run([
      'coffee',
      'injector',
      'wiredep', 
      'express:prod'
    ]);
  });

  grunt.registerTask('build', function (target) {
    grunt.task.run([
      'coffee',
      'injector',
      'wiredep',
      'copy',
    ]);
  });

  grunt.registerTask('serve', function (target) {
    grunt.task.run([
      'coffee',
      'injector',
      'wiredep',
      'copy',
      'express:dev',
      'open',
      'watch'
    ]);
  });

}