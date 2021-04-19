FROM jenkins/jenkins:lts-slim

LABEL MAINTAINER="jandroav@icloud.com"

ENV CASC_JENKINS_CONFIG "/var/jcasc/jenkins.yaml"

### JENKINS CUSTOMIZATION (1) BEGIN ###

COPY jenkins-raspberry/plugins.txt /usr/share/jenkins/ref/

RUN \
  jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

USER 0

### JENKINS CUSTOMIZATION (1) END ###

RUN \
  mkdir -p /var/jcasc && \
  chown -R jenkins:0 /var/jcasc && \
  chmod -R 0770 /var/jcasc

COPY jenkins-raspberry/jenkins.yaml /var/jcasc

# EXPOSE

COPY jenkins-raspberry/locale.xml ${JENKINS_HOME}

# VOLUME

# USER

# WORKDIR

# ENTRYPOINT

# CMD