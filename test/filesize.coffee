
should = require 'should'
prink = require '../src'

describe 'filesize', ->

  it 'format', ->
    prink.filesize(289128045).should.eql '276 MB'
    prink.filesize(289128045, 2).should.eql '275.73 MB'

  it 'format bit', ->
    prink.filesize.bit(289128045).should.eql '2 Gb'
    prink.filesize.bit(289128045, 2).should.eql '2.15 Gb'

  it 'format to unit', ->
    prink.filesize.to.kilobytes(289128045).should.eql '282352 KB' # 282351,6064453125
    prink.filesize.to.gigabytes(289128045, 2).should.eql '0.27 GB' # 275.73
    prink.filesize.to.Mb(12382232, 2).should.eql '94.47 Mb'

  it 'format from unit', ->
    prink.filesize.from.megabytes(289128045).should.eql '276 TB'

  it 'format from and to unit', ->
    prink.filesize.from.megabytes.to.petabytes(289128045, 2).should.eql '0.27 PB' # 275.73

  it 'parse', ->
    prink.filesize.parse('276 MB').should.eql 289406976
    # Decimal
    prink.filesize.parse('275.73 MB').should.eql 289123860.48
    # No Space between value and unit
    prink.filesize.parse('276MB').should.eql 289406976
    prink.filesize.parse('275.73MB').should.eql 289123860.48

  it 'parse unit', ->
    prink.filesize.parse.to.kilobytes('276 MB').should.eql 282624

  it 'parse bit', ->
    prink.filesize.parse.bit('276 MB').should.eql 2315255808
    # Decimal
    prink.filesize.parse.bit('275.73 MB').should.eql 2312990883.84
    # No Space between value and unit
    prink.filesize.parse.bit('276MB').should.eql 2315255808
    prink.filesize.parse.bit('275.73MB').should.eql 2312990883.84

  it 'compare', ->
    prink.filesize.compare('100 MB', 289406976).should.not.be.True
    prink.filesize.compare('276 MB', 289406976).should.be.True

  it 'compare bit', ->
    prink.filesize.compare.bit('100 MB', 2315255808).should.not.be.True
    prink.filesize.compare.bit('276 MB', 2315255808).should.be.True



