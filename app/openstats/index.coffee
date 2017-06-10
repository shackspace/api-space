influx = require './influx'
open = require './open'

module.exports =
	init: () ->
		return influx.init().then ->
			open.on 'open', (isOpen) ->
				influx.writeLiveData isOpen
			open.fetch()
			return Promise.resolve()
