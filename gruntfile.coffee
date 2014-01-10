module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-mocha-test"
  grunt.loadNpmTasks "grunt-nodemon"
  grunt.loadNpmTasks "grunt-env"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    meta:
      file: "Gertu"
      banner:
        '/* <%= meta.file %> v<%= pkg.version %> - '                 +
        '<%= grunt.template.today("yyyy/m/d") %>\n'                  +
        '<%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
        '- Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */\n'


    watch:
      options:
        livereload: true
      jade:
        files: ["views/**/*"],                 tasks: ["jade"]
      coffee:
        files: "assets/**/*.coffee",           tasks: ["coffeelint:app", "coffee", "uglify"]
      coffee_server:
        files: "server/**/*.coffee",           tasks: ["coffeelint:server"]
      stylus:
        files: "assets/stylesheets/**/*.styl", tasks: ["stylus", "cssmin"]

    jade:
      options:
        pretty: true
      compile:
        files:[
          expand: true
          cwd   : "views"
          src   : ["**/*.jade", "!pages/management/**/*.jade"]
          dest  : "public/views"
          ext   : ".html"]

    stylus:
      compile:
        options: linenos : true, compress: false
        files  : [
          expand: true
          cwd   : "assets/stylesheets"
          src   :  "**/*.styl"
          dest  : "public/css"
          ext   :  ".css"]

    cssmin:
      minify:
        options: banner: "<%= meta.banner %>"
        files  : [
          expand: true
          cwd   : "public/css/"
          src   : "*.css"
          dest  : "public/"
          ext   : ".min.css"]

    coffee:
      all:
        files: [
          expand: true
          cwd   : "assets",
          src   :  "**/*.coffee"
          dest  : "public/js"
          ext   :  ".js"]
      single:
        files: "public/<%=pkg.name%>.js": ["assets/**/*.coffee"]

    uglify:
      options: mangle: false, compress: true, banner: "<%= meta.banner %>"
      coffee :
        files: "public/<%=pkg.name%>.min.js": ["public/js/**/*.js"]

    coffeelint:
      app      : ["assets/**/*.coffee"]
      server   : ["server/**/*.coffee"]
      gruntfile: "gruntfile.coffee"
      options  :
        max_line_length:     level: "warn", value: 120
        no_throwing_strings: level: "warn"

    clean:
      js    : ["public/js",  "public/<%=pkg.name%>.js", "public/<%=pkg.name%>.min.js"]
      css   : ["public/css", "public/<%=pkg.name%>.min.css"]
      views : ["public/views"]
      images: ["public/img"]
      prod  : ["public/js",  "public/<%=pkg.name%>.js"]

    copy:
      images:
        files:[
          expand: true
          cwd   : "assets/img"
          src   : "**/*"
          dest  : "public/img"
          filter: "isFile"]

    nodemon:
      dev:
        options:
          file             : "server.coffee"
          ignoredFiles     : ["README.md", "node_modules/**", ".DS_Store", ".idea/**"]
          watchedExtensions: ["coffee"]
          watchedFolders   : ["server", "config"]
          debug            : true
          delayTime        : 1
          env              : PORT: 3000
          cwd              : __dirname

    mochaTest:
      test:
        options:
          reporter: "spec"
          require : ["coffee-script", "coverage/blanket"]
        src: ["test/**/*.coffee"]
      coverage:
        options:
          reporter   : "html-cov"
          quiet      : true
          captureFile: "coverage.html"
        src: ["test/**/*.coffee"]

    env:
      test:
        NODE_ENV: "test"

    concurrent:
      tasks  : ["nodemon", "watch"]
      options: logConcurrentOutput: true


  grunt.registerTask "default",     "Main Grunt. Executes all tasks.", [
    "build", "coffeelint:server", "concurrent"]

  grunt.registerTask "build",       "Compiles all files of project.",  [
    "clean", "coffeelint", "jade", "copy", "scripts", "stylesheets"]

  grunt.registerTask "stylesheets", "Compiles the stylesheets.",       [
    "stylus", "cssmin"]

  grunt.registerTask "scripts",     "Compiles the JavaScript files.",  [
    "coffee", "uglify"]

  grunt.registerTask "prod",        "Cleans dev JS files for prod.",   [
    "build", "clean:prod"]

  grunt.registerTask "test",        "Executes the tests of project.",  [
    "env:test", "mochaTest"]