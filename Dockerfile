FROM jenkins/jenkins:lts-slim

LABEL MAINTAINER="jandroav@icloud.com"

ENV CASC_JENKINS_CONFIG "/var/jcasc/jenkins.yaml"

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY --chown=jenkins:jenkins jenkins.yaml /var/jcasc

COPY --chown=jenkins:jenkins locale.xml ${JENKINS_HOME}