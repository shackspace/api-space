influx = require './influx'
powerraw = require './powerraw'

module.exports =
	init: () ->
		return influx.init().then ->
			powerraw.on 'data', (dataset) ->
				influx.writeLiveData dataset
			powerraw.fetch()
			return Promise.resolve()
