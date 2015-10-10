module.exports = (vorpal, options) ->
  logger =
    filter: {}
    formatters: {}
    doLog: (formatter, msg) ->
      if logger.filter formatter
        vorpal.session.log formatter.format msg
    setFilter: (filter) ->
      if typeof filter is 'function'
        logger.filter = filter
      else if typeof filter is 'number'
        logger.filter = (formatter) ->
          return formatter.level >= filter
    addFormatter: (name, level, format) ->
      logger.formatters[name] =
        level: level
        format: format
      logger[name] = (msg) ->
        logger.doLog logger.formatters[name], msg

  vorpal.logger = logger

  #
  #Default settings
  #

  defaultFormatters =
    debug:
      level: 10
      format: (msg) ->
        return "[debug] #{msg}"
    log:
      level: 20
      format: (msg) ->
        return msg
    info:
      level: 20
      format: (msg) ->
        return "[info] #{msg}"
    confirm:
      level:20
      format: (msg) ->
        return "[confirmation] #{msg}"
    warn:
      level: 30
      format: (msg) ->
        return "[warning] #{msg}"
    error:
      level: 40
      format: (msg) ->
        return "[error] #{msg}"
    fatal:
      level: 50
      format: (msg) ->
        return "[fatal] #{msg}"

  for name, formatter of defaultFormatters
    logger.addFormatter name, formatter.level, formatter.format

  logger.setFilter 20
