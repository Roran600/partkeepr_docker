@@ -1,4 +1,4 @@
## bluelotussoftware/partkeepr docker image repository
## roran60/partkeepr docker image repository

This repository is based on [`mhubig/partkeepr`][0]  [`bluelotussoftware/partkeepr`][1]. The [`roran60/partkeepr`][4]
[partkeepr][2] docker has been updated to use recent releases. It includes additional functionality:
* cron
* nano
> The most recent version is: 1.4.0
To use it, you need to have a working [docker][3] installation. Start by running
the following command:
    $ docker run -d -p 80:80 --name partkeepr bluelotussoftware/partkeepr
Or to run it together with a MariaDB database container.
    $ docker-compose up
[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: https://github.com/bluelotussoftware/partkeepr
[2]: http://www.partkeepr.org
[3]: https://www.docker.io 
[4]: https://hub.docker.com/r/roran60/partkeepr