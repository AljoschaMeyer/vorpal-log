log = require './index'

Vorpal = require 'vorpal'
marked = require 'marked'
TerminalRenderer = require 'marked-terminal'

# Needed because too many vorpal emmiters are added otherwise
require('events').EventEmitter.defaultMaxListeners = Infinity

vorpal = null
logger = null

initVorpal = (options) ->
  vorpal = null
  logger = null
  vorpal = Vorpal()
  if options?
    vorpal.use log, options
  else
    vorpal.use log
  logger = vorpal.logger

describe 'The vorpal-log extension', ->
  beforeEach ->
    vorpal = null
    logger = null

  it 'adds a logger object to vorpal', ->
    vorpal = Vorpal()
    expect(vorpal.logger).not.toBeDefined()
    vorpal.use log
    expect(vorpal.logger).toBeDefined()
    expect(vorpal.logger).not.toBeNull()

  it 'saves options as logger.options', ->
    options = {foo: 'bar'}

    vorpal = Vorpal()
    vorpal.use log, options
    expect(vorpal.logger.options).toBe options

describe 'The logger object', ->
  beforeEach ->
    initVorpal()

  it 'has default formatters', ->
    expect(logger.debug).toBeDefined()
    expect(logger.log).toBeDefined()
    expect(logger.info).toBeDefined()
    expect(logger.confirm).toBeDefined()
    expect(logger.warn).toBeDefined()
    expect(logger.error).toBeDefined()
    expect(logger.fatal).toBeDefined()

  it 'has a default filter', ->
    expect(logger.filter).toBeDefined()
    expect(typeof logger.filter).toBe 'function'

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

  it 'set logger.filter to a function returning whether the loglevel is greater then the level of the formatter, for a given name of a formatter', ->
    logger.setFilter 'warn'
    for level in [-10..60]
      expect(logger.filter {level:level}).toBe(level >= logger.formatters['warn'].level)

  it 'throws a TypeError when given string is not a valid name', ->
    expect(logger.formatters['fkföwf']).not.toBeDefined()
    try
      logger.setFilter 'fkföwf'
      expect(true).toBe false
    catch error
      expect(error instanceof TypeError).toBe true

describe 'The addFormatter function', ->
  name = null
  level = null
  format = null
  msg = null

  beforeEach ->
    initVorpal()
    name = 'foo'
    level = 42
    format = (msg) ->
      return "foo: #{msg}"
    msg = 'baz'

  it 'adds the formatter to logger.formatters', ->
    expect(logger.formatters[name]).not.toBeDefined()

    logger.addFormatter name, level, format

    expect(logger.formatters[name].level).toBe level
    expect(logger.formatters[name].format).toBe format

  it 'adds a \'name\' method to logger, which delegates to logger.doLog', ->
    expect(logger[name]).not.toBeDefined()

    logger.addFormatter name, level, format

    expect(typeof logger[name]).toBe 'function'

    spyOn logger, 'doLog'
    logger[name](msg)

    expect(logger.doLog).toHaveBeenCalledWith logger.formatters[name], msg

describe 'The default formatters', ->
  md = '# Foo\n**bar**'
  preformat = (msg) ->
    mdParagraph = marked(md)
    if mdParagraph.lastIndexOf '\n\n' is mdParagraph.length - 2
      mdParagraph = mdParagraph.slice(0, -2)
    return mdParagraph

  beforeEach ->
    initVorpal()

  it 'use the preformat function if defined', ->
    renderedMd = preformat md
    # check that the msg is unchanged if options.preformat isn't set
    for name, formatter of logger.formatters
      expect(formatter.format(md).indexOf md).not.toBe -1
      expect(formatter.format(md).indexOf renderedMd).toBe -1

    logger.options = {}
    logger.options.preformat = preformat
    # check that the msg is preformatted if options.preformat is set
    for name, formatter of logger.formatters
      expect(formatter.format(md).indexOf md).toBe -1
      expect(formatter.format(md).indexOf renderedMd).not.toBe -1
