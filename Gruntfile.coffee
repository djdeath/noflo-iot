module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Install components
    component:
      install:
        options:
          action: 'install'

    # Compiled all components into one file
    componentbuild:
      'noflo-iot':
        options:
          name: 'noflo-iot-pre'
          noRequire: true
          configure: (builder) ->
            # Enable Component plugins
            json = require 'component-json'
            builder.use json()
            # Coffee compilation
            coffee = require 'component-coffee'
            builder.use coffee
        dest: 'build'
        src: './'
        scripts: true
        styles: false

    # Fix broken Component aliases, as mentioned in
    # https://github.com/anthonyshort/component-coffee/issues/3
    combine:
      'noflo-iot':
        input: 'build/noflo-iot-pre.js'
        output: 'build/noflo-iot-pre.js'
        tokens: [
          token: '\\.coffee'
          string: '.js'
        ]

    # Combine custom version of component-require
    concat:
      dist:
        src: ['node_modules/component-require/lib/require.js', 'build/noflo-iot-pre.js']
        dest: 'build/noflo-iot.js'

    # JavaScript minification (Because it's FAST!!!)
    uglify:
      options:
        report: 'min'
      noflo:
        files:
          './build/noflo-iot.min.js': ['./build/noflo-iot.js']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-component'
  @loadNpmTasks 'grunt-component-build'
  @loadNpmTasks 'grunt-combine'
  @loadNpmTasks 'grunt-contrib-concat'
  @loadNpmTasks 'grunt-contrib-uglify'

  # Our local tasks
  @registerTask 'build', ['component', 'componentbuild', 'combine', 'concat', 'uglify' ]
