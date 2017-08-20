FROM jenkins/jenkins:latest

USER root

RUN set -ex \
    && apt-get update && apt-get install -y \
      build-essential \
      sudo \
      supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/supervisor \
    && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && curl -fsSL https://get.docker.com/ | sh \
    && curl -fsSL https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > \
    /usr/local/bin/docker-compose \
    && usermod -a -G sudo jenkins \
    && usermod -a -G docker jenkins

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080
EXPOSE 50000
VOLUME /var/jenkins_home

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon"]
