# magical influx definitions
Keep "live" data an hour
`CREATE RETENTION POLICY "1h" ON "strom" DURATION 1h REPLICATION 1`

Keep hourly and monthly data FOREVER!! **MUAHAHAHA**

```
CREATE CONTINUOUS QUERY "cq_minutely" ON "strom" BEGIN
  SELECT 
		last("total"),
		mean("powerL1"),
		mean("powerL2"),
		mean("powerL3"),
		mean("voltageL1"),
		mean("voltageL2"),
		mean("voltageL3"),
		mean("currentL1"),
		mean("currentL2"),
		mean("currentL3")
  INTO "1h"."minutely"
  FROM "1h"."live"
  GROUP BY time(1m)
END
```

('2017-06-01 11:04:01',146742.0235,
481,233.30,2.11,
409,233.06,2.04,
1365,233.78,6.57,
2002)
