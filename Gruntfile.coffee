module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    jade:
      product:
        options:
          data:
            debug: false
        files:
          "www/index.html": ["src/jade/index.jade"]

    coffee:
      product:
        options:
          bare: true
        expand: true
        cwd: 'src/coffee'
        src: '*.coffee'
        dest: 'src/js/'
        ext: '.js'
      # uglify:
        # product:
          # opitions:
          # file:
    stylus:
      product:
        files:
          'www/assets/css/main.css':'src/stylus/*.styl'

    concat:
      options:
        separator: ";"
      vender:
        src: [
          'app/assets/js/components/jquery/jquery.js'
          'app/assets/js/components/lodash/lodash.js'
          'app/assets/js/components/kazitori.js/src/js/kazitori.js'
          'app/assets/js/libs/tween.min.js'
        ]
        dest: 'app/assets/js/vender.js'
      product:
        src: [
          'src/js/main.js'
        ]
        dest: 'src/dest/main.js'

    uglify:
      vender:
        files:
          'app/assets/js/vender.js': 'app/assets/js/vender.js'

      product:
        files:
          'www/assets/js/main.js': 'src/dest/main.js'

    watch:
      jade:
        files: ["src/jade/*.jade"]
        tasks: ["jade:product"]
      coffee:
        files: ["src/coffee/*.coffee"]
        tasks: ["coffee:product", "concat:product", "uglify:product"]
      stylus:
        files: ["src/stylus/*.styl"]
        tasks: ["stylus:product"]


  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-notify"

  grunt.registerTask "default", ["coffee", "stylus"]
  grunt.registerTask "ci", ["coffee"]
