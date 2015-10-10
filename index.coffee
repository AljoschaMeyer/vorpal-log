chalk = require 'chalk'
marked = require 'marked'
TerminalRenderer = require 'marked-terminal'

module.exports = (vorpal, options) ->
  marked.setOptions {renderer: new TerminalRenderer()}

  # renders md and removes the two trailing newlines
  renderMD = (md) ->
    mdParagraph = marked(md)
    if mdParagraph.lastIndexOf '\n\n' is mdParagraph.length - 2
      mdParagraph = mdParagraph.slice(0, -2)
    return mdParagraph

  logger =
    options: options ? {}
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
      vorpal.session.log msg

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
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.dim '[debug]'} #{msg}"
    log:
      level: 20
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return msg
    info:
      level: 20
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.blue '[info]'} #{msg}"
    confirm:
      level:20
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.green '[confirmation]'} #{msg}"
    warn:
      level: 30
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.yellow '[warning]'} #{msg}"
    error:
      level: 40
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.red '[error]'} #{msg}"
    fatal:
      level: 50
      format: (msg) ->
        msg = renderMD msg if logger.options.markdown
        return "#{chalk.bgRed '[fatal]'} #{msg}"

  for name, formatter of defaultFormatters
    logger.addFormatter name, formatter.level, formatter.format

  logger.setFilter 'info'
