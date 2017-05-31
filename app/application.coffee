config = require '../config'
send = require 'koa-send'
request = require 'co-request'
log4js = require 'log4js'
log = log4js.getLogger 'shackspace-api-space'


module.exports = ->
	koa = require 'koa'
	Router = require 'koa-router'
	koaBody = require('koa-body')()
	cors = require 'koa-cors'
	app = koa()

	app.use(cors())

	router = Router()
	sendIndex = ->
		yield send @, 'index.html', root: config.staticFileDirectory

	router.get '/v1/portal', ->
		try
			portalState = yield request
				url: config.portalUrl
			@body = portalState
		catch error
			log.error error
			@status = 503

	app.use(router.routes()).use(router.allowedMethods())

	return app
