
filesize = require './filesize'

Object.defineProperty module.exports, 'mode', get: ->
  mode = ->
    mode.format arguments...
  mode.format = (value) ->
    if typeof value is 'number' then value.toString(8) else value
  mode.parse = (value) ->
    switch typeof value
      when 'number' then value
      when 'string' then parseInt value, 8
      else throw Error "Invalid value #{JSON.stringify value}"
  mode.compare = (values...) ->
    ref = mode.parse values[0]
    for i in [1...values.length]
      value = mode.parse values[i]
      return false if value isnt ref
    true
  mode

Object.defineProperty module.exports, 'filesize', get: ->
  options = action: 'format'
  run = ->
    throw Error if options.action not in ['format', 'parse', 'compare']
    filesize[options.action].call null, arguments..., options
  build = ->
    builder = ->
      run.apply builder, arguments
    # __proto__ is used because we must return a function, but there is
    # no way to create a function with a different prototype.
    builder.__proto__ = proto
    builder
  result = ->
    result.format arguments...
  properties = 
    format: get: ->
      options.action = 'format'
      build()
    parse: get: ->
      options.action = 'parse'
      build()
    compare: get: ->
      options.action = 'compare'
      build()
    bit: get: ->
      options.bit = true
      build()
  directions = ['from', 'to']
  directions.forEach (direction) ->
    properties[direction] = get: ->
      throw Error "Invalid usage of #{direction}" if options.direction
      options.direction = "#{direction}"
      build()
  units = [
    ['KB', 'kilobytes']
    ['MB', 'megabytes']
    ['GB', 'gigabytes']
    ['TB', 'terabytes']
    ['PB', 'petabytes']
    ['EB', 'exabytes']
    ['ZB', 'zettabytes']
    ['YB', 'yottabytes']
    ['Kb', 'kilobits']
    ['Mb', 'megabits']
    ['Gb', 'gigabits']
    ['Tb', 'terabits']
    ['Pb', 'petabits']
    ['Eb', 'exabits']
    ['Zb', 'zettabits']
    ['Yb', 'yottabits']
  ]
  units.forEach (unit) ->
    properties[unit[0]] = get: ->
      throw Error 'Use from or to before unit' unless options.direction in directions
      throw Error "Unit already defined" if options[options.direction]
      options[options.direction] = unit[0]
      options.direction = null
      build()
    properties[unit[1]] = properties[unit[0]]
  proto = Object.defineProperties result, properties
  result

