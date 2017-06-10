Influx = require 'influx'

influx = new Influx.InfluxDB
	host: 'localhost'
	database: 'open'
	schema: [
		measurement: 'live'
		fields:
			open: Influx.FieldType.FLOAT
		tags: []
	]
	
cq_hourly = ->
	return influx.createContinuousQuery "cq_hourly", """
		SELECT 
			mean("open")
		INTO "hourly"
		FROM "1d"."live"
		GROUP BY time(1h)
	"""

init = ->
	return influx.getDatabaseNames().then (names) ->
		if not names.includes 'open'
			return influx.createDatabase('open').then ->
				return influx.createRetentionPolicy '1d',
					duration: '1d',
					replication: 1
				.then ->
					return Promise.all [cq_hourly()]
		return Promise.resolve()
	.catch (err) ->
		console.error 'Error creating Influx database!', err
		return Promise.reject(err)

writeLiveData = (isOpen) ->
	influx.writeMeasurement 'live', [
		fields:
			open: +isOpen
	],
		retentionPolicy: '1d'
		
		
module.exports =
	init: init
	writeLiveData: writeLiveData
	
# CREATE CONTINUOUS QUERY hourly ON open
# BEGIN
# 		SELECT mean("open")
# 		INTO "hourly"
# 		FROM "1h"."live"
# 		GROUP BY time(1h)
# END
