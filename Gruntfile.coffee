module.exports = (grunt)->

  grunt.initConfig

    cfg: grunt.file.readJSON 'config.json'

    copy:
      manifest:
        files: [{
            expand: true
            cwd: 'src/static'
            src: ['**']
            dest: 'target/'
          }]

    clean: ['target', '**/*~', '**/*#*']

    sass:
      target:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: 'src/sass'
          src: ['*.sass']
          dest: 'target/css'
          ext: '.css'
        ]

    haml:
      target:
        options:
          language: 'coffee'
          target: 'html'
        files:
          'target/popup.html': 'src/haml/popup.haml'

    json_generator:
      target:
        dest: 'target/manifest.json'
        options:
          manifest_version: 2
          name: 'RagPicker'
          description: 'Interactive web clipper'
          version: '1.0'
          permissions: [
              '<%= cfg.server %>'
              'tabs'
            ]
          content_scripts: [
              matches: ['*://*/*']
              js: ['vendor/jquery-2.0.3.js', 'js/clipper.js']
            ]
          browser_action:
            default_icon: 'images/rag_picker.png'
            default_popup: 'popup.html'

    browserify:
      target:
        files:
          'target/js/popup.js': ['src/coffee/popup.coffee']
          'target/js/clipper.js': ['src/coffee/clipper.coffee']
        options:
          transform: ['coffeeify']

    watch:
      coffee:
        files: ['src/coffee/**/*.coffee']
        tasks: ['browserify']
      sass:
        files: ['src/sass/**/*.sass']
        tasks: ['sass']
      haml:
        files: ['src/**/*.haml']
        tasks: ['haml']
      static:
        files: ['src/static/**/*']
        tasks: ['copy', 'json_generator']
      all:
        files: ['Gruntfile.coffee']
        tasks: ['default']

  grunt.registerTask 'default', [
      'clean', 'haml', 'sass', 'copy', 'json_generator', 'browserify'
    ]

  grunt.loadNpmTasks "grunt-#{t}" for t in [
      'json-generator'
      'haml'
      'browserify'
    ].concat [
      'copy'
      'clean'
      'sass'
      'watch'
    ].map (f)-> "contrib-#{f}"
