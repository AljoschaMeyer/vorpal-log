module.exports = (vorpal, options) ->
  logger =
    foo: 'bar'

  vorpal.logger = logger
