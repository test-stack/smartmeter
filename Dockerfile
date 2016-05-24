# A image with Smartmeter 1.1.0
FROM develar/java:8u45
MAINTAINER Radim Daniel Pánek <rdpanek@gmail.com>

# main env
ENV SMARTMETER_VERSION 1.1.0
ENV SMARTMETER_DIRECTORY SmartMeter_${SMARTMETER_VERSION}L_Light
ENV SMARTMETER_URL http://smartmeter-api.etnetera.cz/download/release/${SMARTMETER_VERSION}/linux/light/full/${SMARTMETER_DIRECTORY}.tar.gz
ENV SMARTMETER_PATH /srv/var/${SMARTMETER_DIRECTORY}/sm-linux-light-full-${SMARTMETER_VERSION}/

RUN apk add --update curl ca-certificates && \

    # Download smartmeter
    mkdir -p /srv/var/${SMARTMETER_DIRECTORY} && cd /srv/var/${SMARTMETER_DIRECTORY} && \
    curl -o ${SMARTMETER_DIRECTORY}.tar.gz ${SMARTMETER_URL} && \
    tar -zxf ${SMARTMETER_DIRECTORY}.tar.gz && rm ${SMARTMETER_DIRECTORY}.tar.gz && \

    # Download depending
    cd ${SMARTMETER_PATH}programs/apache-jmeter/lib && \
    curl -L -o elasticsearch-2.3.2.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/elasticsearch-2.3.2.jar" && \
    curl -L -o hppc-0.7.1.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/hppc-0.7.1.jar" && \
    curl -L -o jackson-core-2.6.2.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/jackson-core-2.6.2.jar" && \
    curl -L -o joda-time-2.8.2.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/joda-time-2.8.2.jar" && \
    curl -L -o jsr166e-1.1.0.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/jsr166e-1.1.0.jar" && \
    curl -L -o lucene-analyzers-common-5.5.0.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/lucene-analyzers-common-5.5.0.jar" && \
    curl -L -o lucene-core-5.5.0.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/lucene-core-5.5.0.jar" && \
    curl -L -o netty-3.10.5.Final.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/netty-3.10.5.Final.jar" && \
    curl -L -o t-digest-3.0.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/lib/t-digest-3.0.jar" && \

    # Remove old .jar
    rm -rf jackson-core-2.4.4.jar netty-3.5.5.Final.jar && \

    # Download Elasticsearch Backend Listener
    cd ${SMARTMETER_PATH}programs/apache-jmeter/lib/ext/ && \
    curl -L -o ElasticSearchBackendListenerClient.jar "https://github.com/test-stack/elasticSearchBackendListenerClient/raw/master/out/artifacts/ElasticSearchBackendListenerClient/ElasticSearchBackendListenerClient.jar" && \
    apk del curl ca-certificates

WORKDIR ${SMARTMETER_PATH}
ENTRYPOINT ["./SmartMeter.sh", "runTestNonGui"]
