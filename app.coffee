express = require 'express'
exphbs = require 'express3-handlebars'
littleprinter = require 'littleprinter'
Handler = require './handler'

app = express()
handler = new Handler(app)
port = process.env.PORT || 7000
app.engine('handlebars', exphbs({defaultLayout: 'main'}))

app.set('view engine', 'handlebars')

littleprinter.setup(app, handler.json())

app.post '/validate_config', (req, res) ->

  return res.send(400) unless req.query.config? or res.query.test?

  response = {
    errors: []
    valid: true
  }

  # if !req.query.config.feedURL?
  #   response.errors.push 'Please enter a valid iDoneThis URL'
  #   response.valid = false

  return res.type('json').status(200).send(response)

app.listen(port)

module.exports = app
