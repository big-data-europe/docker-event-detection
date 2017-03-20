# docker-bde-event-detection-sc7
The docker image for the event detection module of the SC7 pilot of the BigDataEurope Project

[![](https://images.microbadger.com/badges/image/bde2020/event-detection.svg)](http://microbadger.com/images/bde2020/event-detection "Get your own image badge on microbadger.com")
## Basics
### Getting the image
Install the [docker](https://www.docker.com/) platform.

Get the sc7 event detection module image directly from the [docker hub](https://hub.docker.com/r/bde2020/event-detection/)  by running
```bash
$ docker pull bde2020/event-detection
```

Alternatively, you can clone this repository, navigate to its directory and running
```bash
$ docker build -t event-detection .
```
to build and specify a name and tag for the image you can use the `-t imagename:imagetag` arguments.

Everything should work with the default build arguments. If however there is some conflict with the preset values and your application, you can modify them by editing the Dockerfile or using
```bash
docker build -t event-detection --build-arg argument_name=argument_value .
```
Note that modifying a build argument requires rebuilding the docker image.

### Running the image
To run a named container and land on an interactive shell, execute
```bash
docker run --name="event-detection-container" -it event-detection bash
```

If you nare having problems with port forwarding from within the container, consider using  the `--net=host` parameter.

See the [Docker Docs](https://docs.docker.com/) for further information.

### Init-daemon
The container includes scripts to communicate with an init-daemon service which authorizes and records module initialization, execution and completion (see scripts at `daemon` folder). The default URI of the service is specified by `$INIT_DAEMON_BASE_URI`. If the service is not running, you can override it for testing purposes by providing your own URI, or disabling the init-daemon alltogether with the `$ENABLE_INIT_DAEMON` variable. You can also override the daemon directory location in the container in case of conflict, via the relevant build argument. The init-daemon is disabled by default.


## Execution details
### Modules and run modes
The image supports the run modes:
- **news** : for crawling / fetching news article content
- **tweets** : for crawling / fetching twitter content
- **location** : for location detection and geometry extraction per document
- **cluster** : for event detection and summarization

To run each task, you should use the driver script at `/driver.sh`, to ensure proper initialization.
For example, to run the news crawler, launch the container and run the script as shown below.
```bash
$ docker run -it event-detection bash
$ /driver.sh news
```
where `event-detection` is the image name.

Passing `pipeline` or no arguments at all to the driver script, runs all the modules sequentially in the order `newscrawler`, `twittercrawler`, `locationextractor`, `clusterer`.
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
### Pre-supplying module parameters
In order to automate running containers at pre-set settings, users can provide configuration files for the modules to use, instead of editing each separately every time. All user-supplied files  are passed to the container via [data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), at the directory specified by the `$MOUNTDIR` build argument. Supplied configuration files are copied from `$MOUNTDIR` to their appropriate folders to be used by the program, i.e. `$BDE_ROOT_DIR/BDEEventDetection/<module>/res/<parametersfile>`. For a list of all suppliable configuration files, see the build arguments prefixed by `SUPPLIED` at the Dockerfile.

A synopsis follows, where paths are assumed to be relative, from a base directory of `$MOUNTDIR`. Note that each property file can (and should) be copied form `$BDE_ROOT_DIR/BDEEventDetection/skel/` and edited as desired, following the instructions in each skel property file. You can use the script `/skel.sh` to quickly copy all relevant property and source files to the user - supplying directory.

#### Authentication parameters
To connect to the database backend(s) and the twitter api, provide authentication credential files at `$CONNECTIONS_CONFIG_FOLDER`. Default value is `$MOUNTDIR/connection` :
- `connection/cassandra.conf`, for the cassandra backend.
- `connection/mysql.conf`, for the mysql backend.
- `connection/twitter.conf`, for the twitter api.

For the required format per file, see `exec/connections_config.sh`

#### News crawler parameters
Provide `news.properties` and `news.urls` files. Running in `crawl` mode requires a feed url per line at the second file. In `fetch` mode you can provide a list of article urls instead, and they will be individually fetched and stored.

#### Twitter crawler parameters
Provide `twitter.properties` and `twitter.queries` and/or `twitter.accounts` files. The resource files depend on operation mode, i.e. `search` for keyword search using `twitter.queries` in the format `searchtoken***lang***numResults` per line (e.g. `neuralnets***en***100`), `monitor`, using `twitter.accounts` in the format `accountName***true***numResults` per line, and `fetch`. The last mode reads a twitter ID per line on the file specified by the `twitter_ids_fetch_file` property in the `twitter.properties` file, and mines it individually.

#### Location extractor parameters
Provide `location.properties` and `locextractor.properties` files. The latter is mandatory when using a RESTFul extractor (`extractor` property in the properties) or applying results filtering. The module also supports entity extraction from RESTful extractors, using a queriable thesaurus. Refer to the instructions in each file for more details.

#### Event clusterer parameters
Provide `clustering.properties` file. The `operation_mode` property controls whether the clustering procedure will be scaled using [Apache Spark](http://spark.apache.org/), or run in parallel at the local machine.

#### Common properties
Apart from module-specific properties, common ones include:
- `repository_impl`: Backend storage type selection, i.e. cassandra or mysql
- Backend connection credentials
- `modifiers`: boolean tags specifying module behavior (e.g. `verbose`)

#### shortcuts
To quickly edit installed module parameters, run `/setProperties.sh`. Use `/setSources.sh` to edit crawling resource files (urls, tweet searches, etc) and `setAuth.sh` to create the authentication parameter files.


#### Logs
Run logs are located in `/var/log/bde/`, timestamped and named as per module and run mode (`pipeline`, `cron`,`initialization` or regular single-module name for isolated, one-time runs). You can use the `/log.sh` helper script to  check them out.

### RESTFul services
#### twitter-rest
This service launches an api that receives a list of twitter ids via http POST and stores them in a file. The latter  can be used to set the twitter crawler to mine these tweets, when run in fetch mode. See the [api repository (https://github.com/npit/twitterRest)] and `$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.properties`.
