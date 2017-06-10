Influx = require 'influx'

influx = new Influx.InfluxDB
	host: 'localhost'
	database: 'open'
	schema: [
		measurement: 'live'
		fields:
			open: Influx.FieldType.BOOLEAN
		tags: []
	]

init = ->
	return influx.getDatabaseNames().then (names) ->
		if not names.includes 'open'
			return influx.createDatabase('open').then ->
				return influx.createRetentionPolicy '1h',
					duration: '1h',
					replication: 1
				.then ->
					return Promise.all []
		return Promise.resolve()
	.catch (err) ->
		console.error 'Error creating Influx database!', err
		return Promise.reject(err)

writeLiveData = (isOpen) ->
	influx.writeMeasurement 'live', [
		fields:
			open: isOpen
	],
		retentionPolicy: '1h'
		
		
module.exports =
	init: init
	writeLiveData: writeLiveData
