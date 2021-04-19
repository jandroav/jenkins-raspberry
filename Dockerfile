FROM jenkins/jenkins:lts-slim

LABEL MAINTAINER="jandroav@icloud.com"

ENV CASC_JENKINS_CONFIG "/var/jcasc/jenkins.yaml"

### JENKINS CUSTOMIZATION (1) BEGIN ###

COPY plugins.txt /usr/share/jenkins/ref/

#RUN \
  #jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

#COPY jenkins.yaml /var/jcasc

# EXPOSE

#COPY locale.xml ${JENKINS_HOME}

# VOLUME

# USER

# WORKDIR

# ENTRYPOINT

# CMD