vorpal = (require 'vorpal')()
vorpalLog = require '../index'

vorpal.use vorpalLog, {markdown: true}
  .delimiter 'vorpal-log demo $'
  .show()

logger = vorpal.logger

vorpal.command 'log'
  .description 'log some highly important information'
  .action (args, cb) ->
    logger.printMsg ''
    logger.debug 'Log command called without arguments.'
    logger.log '*Foo*, **bar**, `baz`!'
    logger.confirm 'You successfully ran the `log` command.'
    logger.info 'It logs stuff.'
    logger.warn 'Careful with that axe, Eugene!'
    logger.error 'Something went wrong...'
    logger.fatal 'If this was a real program, it would probably shut down now.'
    logger.printMsg ''
    cb()

logger.printMsg ''
logger.info 'This is a demo program for the vorpal-log extension.'
logger.info 'Run log to produce some output.'
logger.info 'Run loglevel <level> to change the level, e.g. \'loglevel warn\''
logger.printMsg ''
