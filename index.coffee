module.exports = (vorpal, options) ->
  logger =
    doLog: (formatter, msg) ->
      if logger.filter formatter
        vorpal.session.log formatter.format msg
    setFilter: (filter) ->
      if typeof filter is 'function'
        logger.filter = filter
      else if typeof filter is 'number'
        logger.filter = (formatter) ->
          return formatter.level >= filter

  vorpal.logger = logger

  #
  #Default settings
  #

  logger.setFilter 20
