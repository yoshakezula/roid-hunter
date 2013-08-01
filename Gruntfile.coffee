module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    requirejs: 
      compile:
        options:
          name: 'app'
          baseUrl: "public/js"
          mainConfigFile: "config.js"
          out: "public/js/compiled.js"
    coffee:
      compile:
        files:
          'public/js/app.js': 'public/coffee/app.coffee'
    stylus:
      compile:
        options:
          "include css": true
        files:
          'public/stylesheets/app.css' : 'public/stylesheets/app.styl'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-stylus'

  grunt.registerTask 'default', ['coffee', 'requirejs', 'stylus']