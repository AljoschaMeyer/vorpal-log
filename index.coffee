chalk = require 'chalk'

util = require 'util'

module.exports = (vorpal, options) ->
  logger =
    options: options ? {}
    filter: {}
    formatters: {}
    doLog: (formatter, msg) ->
      if logger.filter formatter
        if vorpal.activeCommand?
          vorpal.activeCommand.log formatter.format msg
        else
          vorpal.log formatter.format msg

    setFilter: (filter) ->
      if typeof filter is 'function'
        logger.filter = filter
      else if typeof filter is 'number'
        logger.filter = (formatter) ->
          return formatter.level >= filter
      else if typeof filter is 'string'
        try
          lvl = logger.formatters[filter].level
          logger.filter = (formatter) ->
            return formatter.level >= lvl
        catch error
          throw new TypeError 'Not the name of a formatter'
      else
        throw new TypeError 'filter must be a number, the name of a formatter, or a filter function'

    printMsg: (msg) ->
      if vorpal.activeCommand?
        vorpal.activeCommand.log msg
      else
        vorpal.log msg

    addFormatter: (name, level, format) ->
      logger.formatters[name] =
        level: level
        format: format
      logger[name] = (msg) ->
        logger.doLog logger.formatters[name], msg

  vorpal.logger = logger

  vorpal.command 'loglevel <level>'
    .description 'set the log level'
    .hidden()
    .action (args, cb) ->
      try
        logger.setFilter args.level
      catch
        logger.error "#{args.level} is not a valid loglevel."
      cb()

  #
  #Default settings
  #

  defaultFormatters =
    debug:
      level: 10
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.dim '[debug]'} #{msg}"
    log:
      level: 20
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return msg
    info:
      level: 20
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.blue '[info]'} #{msg}"
    confirm:
      level: 20
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.green '[confirmation]'} #{msg}"
    warn:
      level: 30
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.yellow '[warning]'} #{msg}"
    error:
      level: 40
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.red '[error]'} #{msg}"
    fatal:
      level: 50
      format: (msg) ->
        if typeof msg is 'string'
          msg = logger.options.preformat msg if logger.options.preformat?
        else
          msg = util.inspect msg

        return "#{chalk.bgRed '[fatal]'} #{msg}"

  for name, formatter of defaultFormatters
    logger.addFormatter name, formatter.level, formatter.format

  logger.setFilter 'info'
