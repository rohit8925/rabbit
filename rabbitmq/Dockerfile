# V3.0 REDIS
# Dockerfile to build basic Redis container Based on Oracle Linux 7 - Slim
FROM cne-repos1.us.oracle.com:7744/apps/cgbu/omc/common/keep/oracle/oraclelinux:7-slim

# File Author / Maintainer
LABEL maintainer="sandeep.j.kumar@oracle.com"

# Set environment variables.
ENV REDIS_HOME_PATH /ugbu-server/service/redis-4.0.6/src
ENV REDIS_HOME=$REDIS_HOME_PATH
ENV PATH $REDIS_HOME:$PATH

# Create Directories to contain Redis dependent RPMs
RUN     mkdir -p /ugbu-server/temp/rpm-deps && \
        mkdir -p /ugbu-server/service/redis-4.0.6 && \
        mkdir -p /ugbu-server/chassis && \
        mkdir -p /ugbu-server/secrets && \
        mkdir -p /ugbu-server/config/redis-4.0.6 && \
        mkdir -p /ugbu-server/embedded_jre

# Copy the RPM file from Server to Redis Container
COPY bin/redis-4.0.6.tar /ugbu-server/temp/
COPY rpm-deps/*.rpm /ugbu-server/temp/rpm-deps/

# Install Redis & its dependent RPMs.
RUN     useradd -d /ugbu-server/service/redis-4.0.6 -u 1001 -o -g 0 redis
RUN 	rpm -Uvh /ugbu-server/temp/rpm-deps/*.rpm && \
	tar -xvf /ugbu-server/temp/redis-4.0.6.tar -C /ugbu-server/service/ && \
	make -C /ugbu-server/service/redis-4.0.6/ && \
	cp /ugbu-server/service/redis-4.0.6/redis.conf /ugbu-server/config/redis-4.0.6/ && \
	rm -rf /ugbu-server/temp/*.tar && \
	rm -rf /ugbu-server/temp/rpm-deps

# Set permissions
RUN chown -R 1001:0 /ugbu-server && chmod -R ug+rw /ugbu-server && \
    find /ugbu-server/config -type d -exec chmod g+x {} + && \
    find /ugbu-server/service/redis-4.0.6 -type d -exec chmod g+x {} +

USER 1001

# Define mountable directories.
VOLUME ["/ugbu-server"]

# Define working directory.
WORKDIR /ugbu-server/service/redis-4.0.6

# Define default command.
ENTRYPOINT ["redis-server", "/ugbu-server/config/redis-4.0.6/redis.conf"]

# Expose ports.
EXPOSE 6379

# End
