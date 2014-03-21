DoneThis = require('./DoneThis')

class Handler
  constructor: (@app) ->
    @
  json: ->
    app = @app
    return {
      meta:
        owner_email: "hello@designedbygold.com"
        publication_api_version: "1.0"
        name: "iDoneThis"
        description: "What did you do yesterday?"
        delivered_on: "every day"
        external_configuration: false
        send_timezone_info: true
        send_delivery_count: true
        config:
          fields: [
            {
              type: 'url',
              name: 'feedURL',
              label: "What's your iDoneThis feed URL?"
            }
          ]

      #use default edition handler
      edition: (l, d, other, done) ->
        return done(null, {}) if other.test is true
        return done(400, {}) unless other.feedURL?

        cal = new DoneThis(other.feedURL).loadCalendar()
        cal.on 'parse_completed', =>
          app.locals.descriptions = cal.descriptions
          app.locals.date = cal.niceDate()
          done null, {}

      #use default sample handler
      sample: (done) ->
        cal = new DoneThis('jongold-idonethis.ics').loadCalendar()
        cal.on 'parse_completed', =>
          app.locals.descriptions = cal.descriptions
          app.locals.date = cal.niceDate()
          done null, {}
    }

module.exports = Handler
