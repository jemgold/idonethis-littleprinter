fs = require 'fs'
request = require 'request'
icalendar = require 'icalendar'
express = require 'express'
exphbs = require 'express3-handlebars'
littleprinter = require 'littleprinter'
handler = require './handler'
moment = require 'moment'
EventEmitter = require('events').EventEmitter

class DoneThis extends EventEmitter
  constructor: (@path) ->
    throw 'needs a path' unless @path?

  loadCalendar: ->
    if @path.substr(0, 5) is 'http://'
      @loadURL()
    else
      @loadFile()
    @

  loadFile: ->
    fs.readFile @path, {encoding: 'UTF8'}, (err, data) =>
      throw err if err
      @parseCalendar(data)

  loadURL: ->
    request @path, (err, data) ->
      throw err if err
      @parse_calendar(data.body)

  parseCalendar: (data) ->
    @cal = icalendar.parse_calendar(data)

    d = yesterday()

    dEnd = new Date((d.valueOf() + 24*60*60*1000))

    for event in @cal.events()
      if event.inTimeRange(d, dEnd)
        @descriptions =  event.getPropertyValue('DESCRIPTION').split('\n')
        @date =  moment(event.getPropertyValue('DTSTART')).format('dddd')

    @emit 'parse_completed'

yesterday = ->
  d = new Date()
  d.setDate(d.getDate() - 1)
  d.setHours(0,0,0,0)
  return d

cal = new DoneThis('jongold-idonethis.ics').loadCalendar()

cal.on 'parse_completed', ->
  app.locals.descriptions = @descriptions
  app.locals.date = @date

app = express()
port = process.env.PORT || 7000
app.engine('handlebars', exphbs({defaultLayout: 'main'}))

app.set('view engine', 'handlebars')
littleprinter.setup(app, handler)

app.listen(port)
