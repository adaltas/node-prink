
should = require 'should'
prink = require '../src'

describe 'mode', ->

  it 'format', ->
    prink.mode(0o0644).should.eql '644'
    prink.mode(420).should.eql '644'
    prink.mode(0o1777).should.eql '1777'
    prink.mode(1023).should.eql '1777'

  it 'parse', ->
    prink.mode.parse('644').should.eql 0o0644
    prink.mode.parse('644').should.eql 420
    prink.mode.parse('1777').should.eql 0o1777
    prink.mode.parse('1777').should.eql 1023

  it 'compare', ->
    prink.mode.compare('644', 0o0644).should.be.True
    prink.mode.compare(420, '644').should.be.True
    prink.mode.compare('1777', 0o1777).should.be.True
    prink.mode.compare(1023, '1777').should.be.True

