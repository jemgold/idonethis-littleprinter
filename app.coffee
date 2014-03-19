express = require 'express'
exphbs = require 'express3-handlebars'
littleprinter = require 'littleprinter'
Handler = require './handler'

app = express()
handler = new Handler(app)
port = process.env.PORT || 7001
app.engine('handlebars', exphbs({defaultLayout: 'main'}))

app.set('view engine', 'handlebars')

littleprinter.setup(app, handler.json())

app.listen(port)

process.on 'uncaughtException', (err) ->
  console.error('uncaughtException:', err.message)
  console.error(err.stack)
  process.exit(1)

module.exports = app
