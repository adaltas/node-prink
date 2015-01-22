
module.exports =
  format: (value, decimal=0, options={}) ->
    if arguments.length is 2
      options = decimal
      decimal = 0
    decimal = Math.pow 10, decimal
    value *= 8 if options.bit or options.unit?[1] is 'b'
    for name, power in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
      ref = Math.pow 1024, power + 1
      name += if options.bit or options.unit?[1] is 'b' then 'b' else 'B'
      stop = if options.unit then options.unit is name else value < ref
      return "#{Math.round((value/Math.pow(1024,power))*decimal)/decimal} #{name}" if stop
  parse: (value, options={}) ->
    switch typeof value
      when 'number' then value
      when 'string'
        if match = /^\s*(.+?)\s*?(K|M|G|T|E|Z|Y)?(B|b)\s*$/.exec value
          throw Error 'Incompatible option bit and unit' if options.bit? and options.unit?
          value = match[1]
          for name, power in ['K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
            if name is match[2]
              value *= Math.pow(1024, power+1)
              break
          value /= 8 if match[3] is 'b'
          value *= 8 if options.bit
          if options.unit
            for name, power in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
              if options.unit is "#{name}B"
                value = value / Math.pow 1024, power
              else if options.unit is "#{name}b"
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