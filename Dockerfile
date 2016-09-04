# Pull base image.
# FROM ubuntu:trusty
FROM maven:3-jdk-8
MAINTAINER George Giannakopoulos (ggianna@iit.demokritos.gr)
ARG DAEMON_DIRECTORY="/daemon"
ARG MOUNT_DIR="/mnt"
ARG CONNECTIONS_CONFIG_FILENAME="$MOUNT_DIR/connections.conf"
ARG SUPPLIED_NEWS_PROPS_FILE="$MOUNT_DIR/newsproperties"
ARG SUPPLIED_NEWS_URLS_FILE="$MOUNT_DIR/newsurls"
ARG SUPPLIED_CLUSTER_PROPS_FILE="$MOUNT_DIR/clusterproperties"
ARG SUPPLIED_LOCATION_PROPS_FILE="$MOUNT_DIR/locationproperties"
ARG SUPPLIED_TWITTER_QUERIES_FILE="$MOUNT_DIR/twitterqueries"
ARG SUPPLIED_TWITTER_PROPS_FILE="$MOUNT_DIR/twitterproperties"
LABEL multi.label1="BDE" \
      multi.label2="Event Detection"

########################################
##  Get and build sources
########################################
# Install utils and tools
RUN echo "Installing prerequisites"
RUN apt-get update 
RUN apt-get install -y git curl cron
  
# Make and define working directory.
ENV BDE_ROOT_DIR "/bde"
RUN mkdir -p "$BDE_ROOT_DIR"

# Clone BDE components
RUN echo 'Getting BDE components.'
RUN cd /bde; \
git clone https://github.com/npit/bde-event-detection-sc7.git BDEEventDetection/
RUN  cd "/bde/BDEEventDetection"; git checkout deploy; 

# Temporarily use public SciFY user
ADD bde-mvn-settings.xml /root/.m2/settings.xml


RUN echo 'Preparing build.'
COPY build/* /
RUN bash setparameters.sh

# Get POMs that output dependency jars
# on /<module>/target/dependencies/*
RUN mkdir -p /tmp/poms
COPY exportDependencyPoms/* /tmp/poms/


# HOTFIX  TODO remove
# /////////////////////////////////////
RUN echo >&2  "***********************" && echo >&2 "Adding scify unavailability hotfix, remove when issue is resolved."
# because scify.org repo is unreachable copy the dependencies from the source pc
RUN mkdir -p $BDE_ROOT_DIR/BDEEventDetection/BDECLustering/externalDependencies
COPY scify/jars/* $BDE_ROOT_DIR/BDEEventDetection/BDECLustering/externalDependencies/
# override the problematic module's pom with one that reads the scify deps as external ones
COPY scify/cluster_withScify_systemdeps "/tmp/poms/cluster"
# /////////////////////////////////////

# copy the POMs on their respective module directories
RUN bash /copy_poms_from_folder.sh "/tmp/poms"

RUN echo 'Building.'
# Build
RUN cd /bde/BDEEventDetection;  mvn package;

# clean up build
# remove poms and auxilliary scripts
RUN rm -vrf tmp/poms  
RUN rm -fv /copy_poms_from_folder.sh setparameters.sh

# for debugging, TODO Remove
RUN echo >&2 "*******************" && echo >&2 "Installing nano,netcat for debugging, remove @ production version."
RUN apt-get install -y nano netcat

########################################
##  Add and configure interface 
########################################

### Create environment variables from build args

ENV CONNECTIONS_CONFIG_FILENAME="$CONNECTIONS_CONFIG_FILENAME"
ENV SUPPLIED_NEWS_PROPS_FILE="$SUPPLIED_NEWS_PROPS_FILE"
ENV SUPPLIED_NEWS_URLS_FILE="$SUPPLIED_NEWS_URLS_FILE"
ENV SUPPLIED_CLUSTER_PROPS_FILE="$SUPPLIED_CLUSTER_PROPS_FILE"
ENV SUPPLIED_LOCATION_PROPS_FILE="$SUPPLIED_LOCATION_PROPS_FILE"
ENV SUPPLIED_TWITTER_QUERIES_FILE="$SUPPLIED_TWITTER_QUERIES_FILE"
ENV SUPPLIED_TWITTER_PROPS_FILE="$SUPPLIED_TWITTER_PROPS_FILE"
# create the mount directory to access all user-provided resources
ENV MOUNT_DIR="$MOUNT_DIR"
RUN mkdir -p $MOUNT_DIR

### Daemon interface

RUN echo "Setting up the init-daemon interface."
# declare and set environment variables required for interaction with the 
# init daemon to their default values. Stepname can/will be set at the 
# daemonInterface.sh (TBD)
ENV DAEMON_DIRECTORY "$DAEMON_DIRECTORY"
RUN echo >&2 "****************" && echo >&2 "Disabling the daemon interface for testing".
ENV ENABLE_INIT_DAEMON false
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP default_step_name

# make a dedicated directory for the daemon interface and a mount point
# daemon scripts will be placed there. Is a build arg (default=/daemon).
# also add the DAEMON_DIRECTORY name to /root keep track of the location in a 
# built image 
RUN echo "$DAEMON_DIRECTORY" > /root/daemonDirLoc
RUN mkdir -p $DAEMON_DIRECTORY

# copy the main script that will manage the interface with the remote daemon
# and the query scripts the perform the querying at each stage
# run your work right after the execute-step.sh call
COPY daemon/* $DAEMON_DIRECTORY/

# set the executable bit for the scripts
RUN chmod +x $DAEMON_DIRECTORY/*.sh

# set sleep times for wait - execute - finish daemon probe scripts
ENV SLEEP_WAIT 1
ENV SLEEP_EXEC 1 
ENV SLEEP_FINISH 1

#### Testing:
# To override the default daemon URI ( e.g. for testing purposes ),
# you can  add a override file with another address. 
# Mount as data volume to a mount point and write in it 
# the override  daemon address.

ENV DAEMON_INFO_FILE $DAEMON_DIRECTORY/daemoninfo
RUN echo "init-daemon interface setup complete."
### End of Daemon interface


### Execution
##############
# copy the execution scripts for each module
# set env. variables 
# bde execution scripts directory
ENV EXEC_DIR="/bdex"
# the classpath with all required jars
ENV CLASSPATHFILE $EXEC_DIR/classpathfile
# create folders, copy execution and auxilliary scripts
RUN mkdir -p "$EXEC_DIR"
COPY exec/*  $EXEC_DIR/

# copy the entrypoint driver script
COPY driver.sh /

# set execution bit 
RUN chmod +x $EXEC_DIR/* /driver.sh

# store the environment variables on a file to help with
# cron-scheduled runs
RUN printenv > ~/envvars

# Define default command.
CMD ["/driver.sh"]
