FROM starwarsfan/eisfair-ng-buildcontainer:latest
MAINTAINER Yves Schumann <yves@eisfair.org>

# Configuration for Jenkins swarm

# Default values for potential build time parameters
ARG JENKINS_IP="localhost"
ARG JENKINS_TUNNEL=""
ARG USERNAME="admin"
ARG PASSWORD="admin"
ARG DESCRIPTION="Swarm node with eisfair-ng sdk"
ARG LABELS="linux swarm eisfair-ng-build"
ARG NAME="eisfair-ng-swarm-node"
ARG UID="1000"

# Environment variables for swarm client
ENV JENKINS_URL=http://$JENKINS_IP \
    JENKINS_TUNNEL=$JENKINS_TUNNEL \
    JENKINS_USERNAME=$USERNAME \
    JENKINS_PASSWORD=$PASSWORD \
    EXECUTORS=1 \
    DESCRIPTION=$DESCRIPTION \
    LABELS=$LABELS \
    NAME=$NAME \
    SWARM_PLUGIN_VERSION=3.5

# Setup jenkins account
# Create working directory
# Change user UID
RUN adduser -D -h /home/jenkins -u ${UID} jenkins \
 && echo "jenkins:jenkins" | chpasswd \
 && chown jenkins:jenkins /home/jenkins -R \
 && mkdir -p /data/jenkins-work

# Install OpenJDK
RUN apk add openjdk8

# Start swarm client
ADD "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_PLUGIN_VERSION}/swarm-client-${SWARM_PLUGIN_VERSION}.jar" /data/swarm-client.jar
RUN chown -R jenkins:jenkins /data

# Switch to user jenkins
USER jenkins

# Start ssh
#CMD ["/usr/sbin/sshd", "-D"]

CMD java \
    -jar /data/swarm-client.jar \
    -executors "${EXECUTORS}" \
    -noRetryAfterConnected \
    -description "${DESCRIPTION}" \
    -fsroot /data/jenkins-work \
    -master "${JENKINS_URL}" \
    -tunnel "${JENKINS_TUNNEL}" \
    -username "${JENKINS_USERNAME}" \
    -password "${JENKINS_PASSWORD}" \
    -labels "${LABELS}" \
    -name "${NAME}" \
    -sslFingerprints " "
