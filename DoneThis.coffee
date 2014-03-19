fs = require 'fs'
request = require 'request'
icalendar = require 'icalendar'
moment = require 'moment'
EventEmitter = require('events').EventEmitter

class DoneThis extends EventEmitter
  constructor: (@path) ->
    throw 'needs a path' unless @path?

  loadCalendar: ->
    if @path.substr(0, 4) is 'http'
      @loadURL()
    else
      @loadFile()
    @

  loadFile: ->
    fs.readFile @path, {encoding: 'UTF8'}, (err, data) =>
      throw err if err
      @parseCalendar(data)

  loadURL: ->
    request @path, {'followAllRedirects': true}, (err, data) =>
      throw err if err
      @parseCalendar(data.body)

  parseCalendar: (data) ->
    @cal = icalendar.parse_calendar(data)

    d = yesterday()

    dEnd = new Date((d.valueOf() + 24*60*60*1000))

    for event in @cal.events()
      if event.inTimeRange(d, dEnd)
        @descriptions =  event.getPropertyValue('DESCRIPTION').split('\n')
        @date =  event.getPropertyValue('DTSTART')

        console.log @descriptions

    @emit 'parse_completed'

  niceDate: ->
    moment(@date).format('dddd')

yesterday = ->
  d = new Date()
  d.setDate(d.getDate() - 1)
  d.setHours(0,0,0,0)
  return d

module.exports = DoneThis
