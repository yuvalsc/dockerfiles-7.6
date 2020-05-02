################################################################################
# This Dockerfile was generated from the template at distribution/src/docker/Dockerfile
#
# Beginning of multi stage Dockerfile
################################################################################

################################################################################
# Build stage 0 `builder`:
# Extract elasticsearch artifact
# Install required plugins
# Set gid=0 and make group perms==owner perms
################################################################################

FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.1 AS builder

###RUN for iter in {1..10}; do yum update --setopt=tsflags=nodocs -y &&     yum install --setopt=tsflags=nodocs -y gzip shadow-utils tar &&     yum clean all && exit_code=0 && break || exit_code=$? && echo "yum error: retry $iter in 10s" && sleep 10; done;     (exit $exit_code)

WORKDIR /usr/share/elasticsearch

COPY plugins/*.zip ./
RUN echo y | ./bin/elasticsearch-plugin install --silent file:opendistro_security-1.6.0.0.zip
RUN ./bin/elasticsearch-plugin install --silent file:opendistro-job-scheduler-1.6.0.0.zip
RUN echo y | ./bin/elasticsearch-plugin --silent install file:opendistro_alerting-1.6.0.0.zip
RUN ./bin/elasticsearch-plugin install --silent file:opendistro_sql-1.6.0.0.zip
RUN echo y | ./bin/elasticsearch-plugin install --silent file:opendistro_index_management-1.6.0.0.zip
RUN echo y | ./bin/elasticsearch-plugin install --silent file:opendistro_performance_analyzer-1.6.0.0.zip
RUN rm -rf *.zip

COPY bin/opendistro-tar-install.sh .
COPY bin/opendistro-performance-analyzer.service /usr/lib/systemd/system/opendistro-performance-analyzer.service
COPY bin/performance-analyzer-agent-cli bin/
COPY plugins/opendistro_security/securityconfig/*.yml plugins/opendistro_security/securityconfig/
COPY --chown=1000:0 config/elasticsearch.yml config/elasticsearch.yml
RUN chmod +x bin/performance-analyzer-agent-cli
RUN ./opendistro-tar-install.sh && echo "opendistro_security.ssl.http.enabled_protocols: [\"TLSv1\",\"TLSv1.1\",\"TLSv1.2\"]" >> config/elasticsearch.yml
RUN rm -f opendistro-tar-install.sh

################################################################################
# Build stage 1 (the actual elasticsearch image):
# Copy elasticsearch from stage 0
# Add entrypoint
################################################################################

FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.1

###RUN for iter in {1..10}; do yum update --setopt=tsflags=nodocs -y &&     yum install --setopt=tsflags=nodocs -y nc shadow-utils zip unzip &&     yum clean all && exit_code=0 && break || exit_code=$? && echo "yum error: retry $iter in 10s" && sleep 10; done;     (exit $exit_code)


WORKDIR /usr/share/elasticsearch
###RUN echo "vm.max_map_count=262144" >> /etc/sysctl.conf
COPY --from=builder --chown=1000:0 /usr/share/elasticsearch /usr/share/elasticsearch
COPY --from=builder --chown=1000:0 /usr/lib/systemd/system/opendistro-performance-analyzer.service /usr/lib/systemd/system/opendistro-performance-analyzer.service

EXPOSE 9200 9300 9600

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# Dummy overridable parameter parsed by entrypoint
CMD ["eswrapper"]

################################################################################
# End of multi-stage Dockerfile
################################################################################
