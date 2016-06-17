# Pull base image.
# FROM ubuntu:trusty
FROM maven:3-jdk-8
MAINTAINER George Giannakopoulos (ggianna@iit.demokritos.gr)

LABEL multi.label1="BDE" \
      multi.label2="Event Detection"

# Install main apt utils
RUN apt-get update 
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

#RUN echo 'Getting java 8... Done.'

# Get build tools
RUN echo 'Getting git...'
RUN apt-get install -y git
  
RUN echo 'Getting maven and git... Done.'

# Make and define working directory.
RUN mkdir -p /bde

# Bring BDE components
RUN echo 'Getting components...'
RUN cd /bde; \
git clone https://github.com/ggianna/bde-event-detection-sc7.git BDEEventDetection/
RUN echo 'Getting components... Done.'

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

RUN echo 'Adding custom NewSum components... Done.'

# DEBUG LINES
# RUN ls -l /bde/
# RUN ls -l /bde/BDEEventDetection/


# Update setting files
RUN echo 'Updating setting files...'
# Twitter
RUN sed -i 's/cassandra_hosts = 127[.]0[.]0[.]1/cassandra_hosts = ${CASSANDRA_IPS}/' /bde/BDEEventDetection/BDETwitterListener/res/twitter.properties && \
# RSS
  sed -i 's/cassandra_hosts = 127[.]0[.]0[.]1/cassandra_hosts = ${CASSANDRA_IPS}/' /bde/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties  &&\
# Clustering
  sed -i 's/cassandra_hosts = 127[.]0[.]0[.]1/cassandra_hosts = ${CASSANDRA_IPS}/' /bde/BDEEventDetection/BDECLustering/res/clustering.properties  &&\
# Location extraction
  sed -i 's/cassandra_hosts = 127[.]0[.]0[.]1/cassandra_hosts = ${CASSANDRA_IPS}/' /bde/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties;

RUN echo 'Updating setting files... Done.'

RUN echo 'Building system...'

# RUN echo 'Building components...'
# RUN cd /bde/BDEEventDetection/BDEBase; \
#   mvn install;
# RUN cd /bde/BDEEventDetection/BDETwitterListener; \
#   mvn install;
# RUN   cd /bde/BDEEventDetection/BDERSSCrawler; \
#   mvn install;
# RUN   cd /bde/BDEEventDetection/BDECLustering; \
#   mvn install; \
#   cd /bde/BDEEventDetection/BDELocationExtraction; \
#   mvn install; \
  
RUN  cd /bde/BDEEventDetection; \
  mvn install;


# RUN echo 'Building components... Done.'


 
# Define default command.
CMD ["bash"]