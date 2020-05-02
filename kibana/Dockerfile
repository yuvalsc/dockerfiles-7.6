#
# ** THIS IS AN AUTO-GENERATED FILE **
#

################################################################################
# Build stage 0
# Extract Kibana and make various file manipulations.
################################################################################
FROM docker.elastic.co/kibana/kibana:7.6.1 AS prep_files

# Add tar and gzip
###RUN yum update -y && yum install -y tar gzip deltarpm && yum clean all

WORKDIR /usr/share/kibana

COPY plugins/*.zip ./
RUN ./bin/kibana-plugin --allow-root install --silent file:opendistro_security_kibana_plugin-1.6.0.0.zip
RUN ./bin/kibana-plugin --allow-root install --silent file:opendistro-alerting-1.6.0.0.zip
RUN ./bin/kibana-plugin --allow-root install --silent file:opendistro_index_management_kibana-1.6.0.0.zip
RUN rm -rf *.zip
COPY bin/loadObject.sh bin/
RUN mkdir -p config/savedObjects
COPY config/savedObjects/*.ndjson config/savedObjects/

# Set some Kibana configuration defaults.plugind
COPY --chown=1000:0 config/kibana.yml config/kibana.yml

################################################################################
# Build stage 1
# Copy prepared files from the previous stage and complete the image.
################################################################################
FROM docker.elastic.co/kibana/kibana:7.6.1
EXPOSE 5601

# Bring in Kibana from the initial stage.
COPY --from=prep_files --chown=1000:0 /usr/share/kibana /usr/share/kibana
WORKDIR /usr/share/kibana

COPY --chown=1000:0 bin/kibana-docker /usr/local/bin/kibana-docker

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/usr/local/bin/kibana-docker"]