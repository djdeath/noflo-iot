module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Directory cleaning
    clean:
      'noflo-iot-components':
        src: ['components']
      'noflo-iot':
        src: ['build']

    # Install components
    component:
      'noflo-iot':
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
      'noflo-iot':
        src: ['node_modules/component-require/lib/require.js', 'build/noflo-iot-pre.js']
        dest: 'build/noflo-iot.js'
      'noflo-iot-bin':
        src: ['header.js', 'build/noflo-iot.js', 'aliases.js', 'server.js']
        dest: 'build/noflo-iot-bin.js'

    # JavaScript minification (Because it's FAST!!!)
    uglify:
      'noflo-iot':
        options:
          report: 'min'
        files:
          './build/noflo-iot.min.js': ['./build/noflo-iot.js']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-component'
  @loadNpmTasks 'grunt-component-build'
  @loadNpmTasks 'grunt-combine'
  @loadNpmTasks 'grunt-contrib-concat'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-contrib-clean'

  # Our local tasks
  @registerTask 'build-components', ['component:noflo-iot', 'componentbuild:noflo-iot', 'combine:noflo-iot', 'concat:noflo-iot', 'uglify:noflo-iot']
  @registerTask 'build', ['build-components', 'concat:noflo-iot-bin']

  @registerTask 'nuke', ['clean:noflo-iot-components', 'clean:noflo-iot']
