# This Dockerfile was generated from templates/Dockerfile.j2
FROM docker.elastic.co/logstash/logstash:7.6.1

# Install Java and the "which" command, which is needed by Logstash's shell
# scripts.
#RUN yum update -y && yum install -y java-11-openjdk-devel which && yum clean all

WORKDIR /usr/share/logstash
#USER logstash:root
# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
COPY --chown=1000:0 config/pipelines.yml config/pipelines.yml
COPY --chown=1000:0 config/logstash.yml config/logstash.yml
COPY --chown=1000:0 pipeline/gpp-readlogs.conf pipeline/gpp-readlogs.conf
RUN rm -f pipeline/logstash.conf
#RUN chown --recursive logstash:root config/ pipeline/

EXPOSE 9600 5044

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
