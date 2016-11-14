# docker-bde-event-detection-sc7
The docker image for the SC7 pilot of BigDataEurope Project

[![](https://images.microbadger.com/badges/image/bde2020/event-detection.svg)](http://microbadger.com/images/bde2020/event-detection "Get your own image badge on microbadger.com")
## Preparation
Install the [docker](https://www.docker.com/) platform
## Build the image
### From docker hub
You can pull the `docker-bde-event-detection-sc7` image directly from the [docker hub](https://hub.docker.com/r/bde2020/event-detection/)  by running
```bash
$ docker pull bde2020/event-detection
```
### From the Dockerfile
Build the docker image by cloning this repository, navigating to its directory and running
```bash
$ docker build -t event-detection .
```
to build and specify a name and tag for the image you can use the `-t imagename:imagetag` arguments. 

### Run
To run a named container and land on an interactive shell, execute
```bash
docker run --name="ed" -it event-detection bash
```

See the [Docker Docs](https://docs.docker.com/) for further information.


### Build arguments
Everything should work with the defaults for the build arguments. If however there is some conflict with the preset values and your application, you can modify them  using
```bash
docker build -t event-detection --build-arg argument_name=argument_value .
```
Note that modifying a build argument requires rebuilding the docker image. 


### Init-daemon
The container includes scripts to communicate with an init-daemon service which authorizes and records module initialization, execution and completion (see scripts at `daemon` folder). The default URI of the service is specified by `$INIT_DAEMON_BASE_URI`. If the service is not running, you can override it for testing purposes by providing your own URI, or disabling the init-daemon alltogether with the `$ENABLE_INIT_DAEMON` variable. You can also override the daemon directory location in the container in case of conflict, via the relevant build argument. The init-daemon is disabled by default.


## Execution
### Modules and run modes
To run the event detection task, you should use the driver script at `/driver.sh`, to ensure proper initialization.
For example, to run the news crawler, launch the container and run the script as shown below.
```bash
$ docker run -it bde_ed bash
$ /driver.sh news
```
Passing `pipeline` or no arguments at all, runs all the modules sequentially in the order `newscrawler`, `twittercrawler`, `locationextractor`, `clusterer`.
To run a cronjob, use the `cron` argument and provide a crontab at `$MOUNT_DIR/bdetab`. Note that to be able to run a module in a cronjob you need to set up the environment in the `sh` system shell cron will launch, with all required bde environment variables. To this end, all required variables are stored in `/root/envvars` during build so you can source them easily. So for example, to run the twitter crawler daily at noon, one should create and execute a crontab like the one below:
```bash
$ docker run -it bde_ed bash
$ cat /mnt/bdetab
0  12    *    *    *   /mnt/cronscript.sh
$ cat /mnt/cronscript.sh
#!/usr/bin/env bash
. "$HOME/envvars"
export $(cat $HOME/envvars | cut -d= -f1)
/driver.sh tweets
$ /driver.sh cron

```
To review all available modules and modes, execute `/driver.sh help`. 
### Run parameters
All user-supplied files  are passed to the container via [data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes) to the container, as we did in examples above. You can control the mount point in the container via the `$MOUNTDIR` build argument. 
To specify the database endpoint connection parameters and the twitter developer credentials, you should provide respective `.conf` files inside the `$CONNECTIONS_CONFIG_FOLDER` folder, each being in the format shown below. For example, a valid connections folder could contain:
```bash
$ pwd
/path/to/connection/folder
$ tail ./*
==> ./cassandra.conf <==
# cassandra connection file
hostIP
port
keyspace_name
cluster_name

==> ./mysql.conf <==
# mysql connection file
mysql://hostIP:hostPort/database_name?option1=value1
database_name
database_user
database_password

==> ./twitter.conf <==
# twitter dev. account credentials file
key
keysecret
token
tokensecret
```

where the sensitive information is replaced with dummy values.

If you need cassandra to operate on a port in the host machine (for example if the cassandra repository is accessed via ssh port forwarding to a remote machine) run the container with the `--net=host` parameter and use `127.0.0.1` and the same port number in the connections file.


You can provide feed urls for the news crawler  by providing `$MOUNTDIR/newsurls`,  files. News crawling urls should be newline-delimited RSS feeds. The twitter crawler receives twitter search literals or monitor accounts from files in `$MOUNTDIR/twitterqueries` and `$MOUNTDIR/twitteraccounts`. The crawler run mode can be specified by providing a `$MOUNTDIR/twitterrunmode` file, containg one of the available run modes: `search`,`monitor`,`stream` or `fetch`.
Supplied twitter queries should follow the format `searchtopic***language***maxnumber`and accounts should be structured as `accountName***true` per line.

If you know what you're doing, you can specify entire detailed run property files for each module in the same way. Check the `Dockerfile` for the relevant filenames in the build arguments.
### Logs
Run logs are located in `/var/log/bde/`, timestamped and named as per module and run mode (`pipeline`, `cron`,`initialization` or regular single-module name for isolated, one-time runs). 
