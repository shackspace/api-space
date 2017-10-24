net = require 'net'
{ EventEmitter } = require 'events'
log4js = require 'log4js'
log = log4js.getLogger 'powerraw'
DATA_REGEX = /^1-0:(\d+)\.(\d+)\.0\*(\d+)\(\+?(.+?)(\*[AVW])?\)/
# groups: type, type2, type3, value

FETCH_INTERVAL = 5000

class Powerraw extends EventEmitter
	fetch: () =>
		client = new net.Socket()
		client.connect 11111, 'powerraw.shack'
		client.on 'data', (data) =>
			rawDataset = {}
			for line in data.toString('ascii').split('\n')
				match = line.match DATA_REGEX
				continue if not match
				rawDataset[match[1]] = match[4]
			dataset =
				total: parseFloat rawDataset['1']
				powerL1: parseInt rawDataset['21']
				powerL2: parseInt rawDataset['41']
				powerL3: parseInt rawDataset['61']
				voltageL1: parseFloat rawDataset['32']
				voltageL2: parseFloat rawDataset['52']
				voltageL3: parseFloat rawDataset['72']
				currentL1: parseFloat rawDataset['31']
				currentL2: parseFloat rawDataset['51']
				currentL3: parseFloat rawDataset['71']
			@currentDataset = dataset
			@emit 'data', dataset
			# log.trace 'read live data'

		client.on 'error', =>
			setTimeout @fetch, FETCH_INTERVAL
		client.on 'close', =>
			setTimeout @fetch, FETCH_INTERVAL

module.exports = new Powerraw()
