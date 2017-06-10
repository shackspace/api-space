{ EventEmitter } = require 'events'
request = require 'request-promise'
config = require '../../config'

FETCH_INTERVAL = 60000

class Openfetcher extends EventEmitter
	fetch: () =>
		request(config.portalUrl, json: true).then((portalState) =>
			@emit 'open', portalState.status is 'open'
		)
		setTimeout @fetch, FETCH_INTERVAL

module.exports = new Openfetcher()
