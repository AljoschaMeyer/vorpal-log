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

  logger.setFilter 20
