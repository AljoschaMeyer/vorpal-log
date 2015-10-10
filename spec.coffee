log = require './index'

Vorpal = require 'vorpal'

vorpal = null
logger = null

initVorpal = ->
  vorpal = Vorpal()
  vorpal.use log
  logger = vorpal.logger

describe 'The vorpal-log extension', ->
  it 'adds a logger object to vorpal', ->
    vorpal = Vorpal()
    expect(vorpal.logger).not.toBeDefined()
    vorpal.use log
    expect(vorpal.logger).toBeDefined()
    expect(vorpal.logger).not.toBeNull()

describe 'The logger object', ->
  beforeEach ->
    initVorpal()

  it 'has a default filter', ->
    expect(logger.filter).toBeDefined()
    expect(typeof logger.filter).toBe 'function'
  # TODO chec default filter is setFilter('info')

describe 'The setFilter function', ->
  beforeEach ->
    initVorpal()

  it 'sets logger.filter to filter if it is a function', ->
    fnc = (formatter) ->
      return true

    expect(logger.filter).not.toBe fnc
    logger.setFilter fnc
    expect(logger.filter).toBe fnc

  it 'sets logger.filter to a function returning whether the loglevel is greater than the number, for a given number', ->
    for f in [-5..15]
      logger.setFilter f
      for level in [-10..20]
        expect(logger.filter {level: level}).toBe(level >= f)

  # TODO name to formatter
  # TODO error else
