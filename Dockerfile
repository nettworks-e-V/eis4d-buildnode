FROM nettworksevtooling/eis4d-buildcontainer:latest
MAINTAINER Yves Schumann <yves@eisfair.org>

# Configuration for Jenkins swarm

# Default values for potential build time parameters
ARG JENKINS_IP="localhost"
ARG JENKINS_TUNNEL=""
ARG USERNAME="admin"
ARG PASSWORD="admin"
ARG DESCRIPTION="Swarm node with eis4d sdk"
ARG LABELS="linux swarm eis4d"
ARG NAME="eis4d"
ARG UID="1058"
ARG GID="1007"

# Environment variables for swarm client
ENV JENKINS_URL=http://$JENKINS_IP \
    JENKINS_TUNNEL=$JENKINS_TUNNEL \
    JENKINS_USERNAME=$USERNAME \
    JENKINS_PASSWORD=$PASSWORD \
    EXECUTORS=1 \
    DESCRIPTION=$DESCRIPTION \
    LABELS=$LABELS \
    NAME=$NAME \
    SWARM_PLUGIN_VERSION=3.7 \
    WORK_DIR=/data/work

# Setup jenkins account
# Create working directory
# Change user UID and GID
RUN groupadd --gid ${GID} jenkins \
 && useradd --create-home --home-dir /home/jenkins --shell /bin/bash --uid ${UID} --gid ${GID} jenkins \
 && echo "jenkins:jenkins" | chpasswd \
 && chown jenkins:jenkins /home/jenkins -R

# Install OpenJDK
RUN apt-get install -y \
    openjdk-11-jdk \
 && apt-get clean

# Mount point for Jenkins .ssh folder
VOLUME /home/jenkins/.ssh

# Install swarm client
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
    -fsroot "${WORK_DIR}" \
    -master "${JENKINS_URL}" \
    -tunnel "${JENKINS_TUNNEL}" \
    -username "${JENKINS_USERNAME}" \
    -password "${JENKINS_PASSWORD}" \
    -labels "${LABELS}" \
    -name "${NAME}" \
    -sslFingerprints " "
