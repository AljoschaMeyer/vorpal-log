log = require './index'

Vorpal = require 'vorpal'

vorpal = null

initVorpal = ->
  vorpal = Vorpal()
  vorpal.use log

describe 'The vorpal-log extension', ->
  it 'adds a logger object to vorpal', ->
    vorpal = Vorpal()
    expect(vorpal.logger).not.toBeDefined()
    vorpal.use log
    expect(vorpal.logger).toBeDefined()
    expect(vorpal.logger).not.toBeNull()
