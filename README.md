# The shackspace space api
## Things relevant to the physical space and services therein

Mainly proxies requests for the external api.

Provides endpoints ( see app/application.coffee and config.coffee )
- /v1/portal -> http://portal.shack:8088/status  
_Implemented at [??? Insert link to git repo here ???](http://example.com)_
- /v1/online -> http://shackles.shack/api/online  
_Implemented at [shackles](https://github.com/shackspace/shackles)_
- /v1/stats/portal  
_Implemented here - fetches open stats from influxdb at localhost_

## Features include, but are not limited to

- portal/door state!
- shackles online users!
- power usage statistics!
- portal/door statistics!

Go to [http://api.shack:3000](http://api.shack:3000) for graphical stats.
