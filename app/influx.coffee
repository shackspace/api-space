Influx = require 'influx'

influx = new Influx.InfluxDB
	host: 'localhost'
	database: 'strom'
	schema: [
		measurement: 'live'
		fields:
			total: Influx.FieldType.FLOAT
			powerL1: Influx.FieldType.FLOAT
			powerL2: Influx.FieldType.FLOAT
			powerL3: Influx.FieldType.FLOAT
			voltageL1: Influx.FieldType.FLOAT
			voltageL2: Influx.FieldType.FLOAT
			voltageL3: Influx.FieldType.FLOAT
			currentL1: Influx.FieldType.FLOAT
			currentL2: Influx.FieldType.FLOAT
			currentL3: Influx.FieldType.FLOAT
		tags: []
	]
	# ,
	# 	measurement: 'minutely'
	# 	fields:
	# 		total: Influx.FieldType.FLOAT
	# 		powerL1: Influx.FieldType.FLOAT
	# 		powerL2: Influx.FieldType.FLOAT
	# 		powerL3: Influx.FieldType.FLOAT
	# 		voltageL1: Influx.FieldType.FLOAT
	# 		voltageL2: Influx.FieldType.FLOAT
	# 		voltageL3: Influx.FieldType.FLOAT
	# 		currentL1: Influx.FieldType.FLOAT
	# 		currentL2: Influx.FieldType.FLOAT
	# 		currentL3: Influx.FieldType.FLOAT
	# 	tags: []
	# ,
	# 	measurement: 'hourly'
	# 	fields:
	# 		total: Influx.FieldType.FLOAT
	# 		powerL1: Influx.FieldType.FLOAT
	# 		powerL2: Influx.FieldType.FLOAT
	# 		powerL3: Influx.FieldType.FLOAT
	# 		voltageL1: Influx.FieldType.FLOAT
	# 		voltageL2: Influx.FieldTCQ_MINUTELYype.FLOAT
	# 		voltageL3: Influx.FieldType.FLOAT
	# 		currentL1: Influx.FieldType.FLOAT
	# 		currentL2: Influx.FieldType.FLOAT
	# 		currentL3: Influx.FieldType.FLOAT
	# 	tags: []
	# ,
	# 	measurement: 'monthly'
	# 	fields:
	# 		total: Influx.FieldType.FLOAT
	# 		powerL1: Influx.FieldType.FLOAT
	# 		powerL2: Influx.FieldType.FLOAT
	# 		powerL3: Influx.FieldType.FLOAT
	# 		voltageL1: Influx.FieldType.FLOAT
	# 		voltageL2: Influx.FieldType.FLOAT
	# 		voltageL3: Influx.FieldType.FLOAT
	# 		currentL1: Influx.FieldType.FLOAT
	# 		currentL2: Influx.FieldType.FLOAT
	# 		currentL3: Influx.FieldType.FLOAT
	# 	tags: []
	
cq_minutely = ->
	return influx.createContinuousQuery "cq_minutely", """
		SELECT 
			last("total") AS total,
			mean("powerL1") AS powerL1,
			mean("powerL2") AS powerL2,
			mean("powerL3") AS powerL3,
			mean("voltageL1") AS voltageL1,
			mean("voltageL2") AS voltageL2,
			mean("voltageL3") AS voltageL3,
			mean("currentL1") AS currentL1,
			mean("currentL2") AS currentL2,
			mean("currentL3") AS currentL3
		INTO "1h"."minutely"
		FROM "1h"."live"
		GROUP BY time(1m)
	"""
	
cq_hourly = ->
	return influx.createContinuousQuery "cq_hourly", """
		SELECT 
			last("total") AS total,
			mean("powerL1") AS powerL1,
			mean("powerL2") AS powerL2,
			mean("powerL3") AS powerL3,
			median("powerL1") AS median_powerL1,
			median("powerL2") AS median_powerL2,
			median("powerL3") AS median_powerL3,
			max("powerL1") AS max_powerL1,
			max("powerL2") AS max_powerL2,
			max("powerL3") AS max_powerL3,
			min("powerL1") AS min_powerL1,
			min("powerL2") AS min_powerL2,
			min("powerL3") AS min_powerL3,
			mean("voltageL1") AS voltageL1,
			mean("voltageL2") AS voltageL2,
			mean("voltageL3") AS voltageL3,
			median("voltageL1") AS median_voltageL1,
			median("voltageL2") AS median_voltageL2,
			median("voltageL3") AS median_voltageL3,
			max("voltageL1") AS max_voltageL1,
			max("voltageL2") AS max_voltageL2,
			max("voltageL3") AS max_voltageL3,
			min("voltageL1") AS min_voltageL1,
			min("voltageL2") AS min_voltageL2,
			min("voltageL3") AS min_voltageL3,
			mean("currentL1") AS currentL1,
			mean("currentL2") AS currentL2,
			mean("currentL3") AS currentL3,
			median("currentL1") AS median_currentL1,
			median("currentL2") AS median_currentL2,
			median("currentL3") AS median_currentL3,
			max("currentL1") AS max_currentL1,
			max("currentL2") AS max_currentL2,
			max("currentL3") AS max_currentL3,
			min("currentL1") AS min_currentL1,
			min("currentL2") AS min_currentL2,
			min("currentL3") AS min_currentL3
		INTO "hourly"
		FROM "1h"."minutely"
		GROUP BY time(1h)
	"""

init = ->
	return influx.getDatabaseNames().then (names) ->
		if not names.includes 'strom'
			return influx.createDatabase('strom').then ->
				return influx.createRetentionPolicy '1h',
					duration: '1h',
					replication: 1
				.then ->
					return Promise.all [cq_minutely(), cq_hourly()]
		return Promise.resolve()
	.catch (err) ->
		console.error 'Error creating Influx database!', err
		return Promise.reject(err)

writeLiveData = (dataset) ->
	influx.writeMeasurement 'live', [
		fields: dataset
	],
		retentionPolicy: '1h'
		
		
module.exports =
	init: init
	writeLiveData: writeLiveData
