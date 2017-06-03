log4js = require 'log4js'
log = log4js.getLogger 'space-api'

config = require '../config'

influx = require './influx'
powerraw = require './powerraw'
app = require('./application')()

app.use require('koa-static')(config.staticFileDirectory)

app.on 'error', (err) ->
	log.error err

influx.init().then ->
	powerraw.on 'data', (dataset) ->
		influx.writeLiveData dataset
	powerraw.fetch()
	app.listen config.port, ->
		log.info 'server listening on port ' + config.port
