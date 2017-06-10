log4js = require 'log4js'
log = log4js.getLogger 'space-api'

config = require '../config'
powerstats = require './powerstats'
openstats = require './openstats'
app = require('./application')()

app.use require('koa-static')(config.staticFileDirectory)

app.on 'error', (err) ->
	log.error err

Promise.all([powerstats.init(), openstats.init()]).then ->
	app.listen config.port, ->
		log.info 'server listening on port ' + config.port
