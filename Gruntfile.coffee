module.exports = (grunt) ->
  "use strict"

  require("load-grunt-tasks")(grunt)
  require("time-grunt")(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      livereload:
        options:
          livereload: true
        files: [
          'presentation/templates/index.jade'
          'presentation/templates/slides.md'
        ]
      coffeelint:
        files: [
          'Gruntfile.coffee'
          'src/app.coffee'
        ]
        tasks: [
          'coffeelint'
        ]
      createApp:
        files: [
          'presentation/templates/index.jade'
          'presentation/templates/slides.md'
          'src/app.coffee'
        ]
        tasks: [
          'coffee'
          'uglify'
          'shell:runApp'
        ]
    coffeelint:
      all: [
        'Gruntfile.coffee'
        'src/app.coffee'
      ]
    coffee:
      compile:
        options:
          bare: true
        files:
          "bin/app.js": "src/app.coffee"
    uglify:
      option:
        banner: "#!/usr/local/bin/node"
      target:
        files:
          "bin/app.js": ["bin/app.js"]
    shell:
      runApp:
        options:
          stout: true
        command: "node bin/app.min.js"
    connect:
      livereload:
        options:
          port: 9000
          hostname: 'localhost'
          base: 'presentation'
          open: true
          livereload: true

  grunt.registerTask "default", [
    "coffeelint"
    "coffee:compile"
    "uglify"
    "shell:runApp"
  ]
  grunt.registerTask "serve", [
    "default"
    "connect:livereload"
    "watch"
  ]
