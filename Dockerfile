FROM jenkins/jenkins:latest

USER root

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		python-pip \
		python-setuptools \
		supervisor \
	&& mkdir -p /var/log/supervisor \
	&& curl -fsSL https://get.docker.com/ | sh \
	&& pip install docker-compose \
	&& usermod -a -G docker jenkins \
	&& rm -rf /var/lib/apt/lists/*

COPY supervisor/conf.d/docker.conf /etc/supervisor/conf.d/docker.conf
COPY supervisor/conf.d/jenkins.conf /etc/supervisor/conf.d/jenkins.conf

EXPOSE 8080
EXPOSE 50000

VOLUME /var/jenkins_home

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon"]
