
module.exports =
  format: (value, decimal=0, options={}) ->
    if arguments.length is 2
      options = decimal
      decimal = 0
    # [direction, unit] = options.unit.split '_' if options.unit
    decimal = Math.pow 10, decimal
    value *= 8 if options.bit or options.to?[1] is 'b'
    if options.from
      for name, power in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
        if options.from[0] is name
          value = value * Math.pow 1024, power
          value /= 8 if options.from[1] is 'b'
          break
    for name, power in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
      ref = Math.pow 1024, power + 1
      name += if options.bit or options.to?[1] is 'b' then 'b' else 'B'
      stop = if options.to then options.to is name else value < ref
      return "#{Math.round((value/Math.pow(1024,power))*decimal)/decimal} #{name}" if stop
  parse: (value, options={}) ->
    switch typeof value
      when 'number' then value
      when 'string'
        if match = /^\s*(.+?)\s*?(K|M|G|T|E|Z|Y)?(B|b)\s*$/.exec value
          throw Error 'Incompatible option bit and unit' if options.bit? and options.to?
          value = match[1]
          for name, power in ['K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
            if name is match[2]
              value *= Math.pow(1024, power+1)
              break
          value /= 8 if match[3] is 'b'
          value *= 8 if options.bit
          if options.to
            for name, power in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
              if options.to is "#{name}B"
                value = value / Math.pow 1024, power
              else if options.to is "#{name}b"
                value = 8 * value / Math.pow 1024, power
          value
        else throw Error "Invalid value #{JSON.stringify value}"
      else throw Error "Invalid value #{JSON.stringify value}"
  compare: (values..., options) ->
    ref = module.exports.parse values[0], options
    for i in [1...values.length]
      value = module.exports.parse values[i], options
      return false if value isnt ref
    true