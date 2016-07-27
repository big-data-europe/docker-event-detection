# Pull base image.
# FROM ubuntu:trusty
FROM bdebase
MAINTAINER George Giannakopoulos (ggianna@iit.demokritos.gr)
ARG daemon_directory="/daemon"
ARG connections_config_filename="/mnt/connections.conf"
LABEL multi.label1="BDE" \
      multi.label2="Event Detection"

# Install main apt utils
#RUN apt-get update 
#apt-get install -y \
#software-properties-common

# Install Java
#RUN echo 'Getting java 8...'
#
#RUN \
  #echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  #add-apt-repository -y ppa:webupd8team/java && \
  #apt-get update && \
  #apt-get install -y oracle-java8-installer && \
  #rm -rf /var/lib/apt/lists/* && \
  #rm -rf /var/cache/oracle-jdk8-installer


# Define commonly used JAVA_HOME variable
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


# Get build tools


# Make and define working directory.
ENV BDEROOT "/bde"
RUN mkdir -p $BDEROOT



# RUN echo 'Adding custom NewSum components...'
# ADD NewSumClusterer/ ~/.m2/repository/org/scify/NewSumClusterer/
# ADD NewSumClusterer-0.5-BDE-SNAPSHOT.jar /bde/
# ADD NewSumSummarizer/ ~/.m2/repository/org/scify/NewSumSummarizer/
# ADD NewSumSummarizer-1.2-BDE-SNAPSHOT.jar  /bde/
# ADD SocialMediaEvaluator/ ~/.m2/repository/org/scify/SocialMediaEvaluator/
# ADD SocialMediaEvaluator-0.4.1-BDE-SNAPSHOT.jar /bde/
# ADD *.jar /bde/
# ADD *.pom /bde/

# Temporarily use public SciFY user
ADD bde-mvn-settings.xml /root/.m2/settings.xml

# TODO: Use only jars instead of whole repos from SciFY
# ADD registerNSComponents.sh /bde/
# RUN ["/bin/bash", "/bde/registerNSComponents.sh"]




COPY initialize.sh /initialize.sh

RUN echo -n 'Updating setting files...'
COPY connections_config.sh /connections_config.sh

RUN bash /connections_config.sh $connections_config_file \
    && echo "Done updating settings files."






# create a mount directory to mount all user-provided resources
ENV MOUNTDIR /mnt
RUN mkdir -p $MOUNTDIR


# copy the execution scripts for each module
# and set an environment variabe

ENV EXECDIR="/bdex"
RUN mkdir "$EXECDIR"
COPY run.sh runPipeline.sh runNewsCrawling.sh runTwitterCrawling.sh \
  runLocationExtraction.sh runEventClustering.sh $EXECDIR/
RUN chmod +x $EXECDIR/*

# RUN echo 'Building components... Done.'

### Scheduling
##############
# install cron, start the service 
# installed in bde-base

# create a crontab file for root
RUN touch $MOUNTDIR/crontabfile
RUN crontab $MOUNTDIR/crontabfile

### End of scheduling

### Daemon interface
####################
RUN echo "Setting up the init-daemon interface."
# declare and set environment variables required for interaction with the 
# init daemon to their default values. Stepname can/will be set at the 
# daemonInterface.sh (TBD)

ENV ENABLE_INIT_DAEMON false
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP default_step_name

# make a dedicated directory for the daemon interface and a mount point
# daemon scripts will be placed there. Is a build arg (default=/daemon).
# also add the daemon_directory name to /home keep track of the location in a 
# built image 
RUN echo "$daemon_directory" > /home/daemonDirLoc
ENV DAEMON_DIR $daemon_directory
RUN mkdir -p $daemon_directory

# copy the main script that will manage the interface with the remote daemon
# and the query scripts the perform the querying at each stage
# run your work right after the execute-step.sh call

COPY wait-for-step.sh $daemon_directory/
COPY execute-step.sh $daemon_directory/
COPY finish-step.sh $daemon_directory/
COPY daemonInterface.sh $daemon_directory/

# set the executable bit for the scripts
RUN chmod +x $daemon_directory/*.sh

# set sleep times for wait - execute - finish daemon probe scripts
ENV SLEEP_WAIT 1
ENV SLEEP_EXEC 1 
ENV SLEEP_FINISH 1

#### Testing:
# To override the default daemon URI ( e.g. for testing purposes ),
# you can  add a override file with another address. 
# Mount as data volume to a mount point and write in it 
# the override  daemon address.


ENV DAEMON_INFO_FILE $daemon_directory/daemoninfo




RUN echo "init-daemon interface setup complete."
### End of Daemon interface



 
# Define default command.
CMD ["bash"]
