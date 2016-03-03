# A image with Smartmeter 1.1.0
FROM rdpanek/base:2.0
MAINTAINER Radim Daniel Pánek <rdpanek@gmail.com>

# main env
ENV SMARTMETER_VERSION 1.1.0
ENV SMARTMETER_DIRECTORY SmartMeter_${SMARTMETER_VERSION}L_Light
ENV SMARTMETER_URL http://smartmeter-api.etnetera.cz/download/release/${SMARTMETER_VERSION}/linux/light/full/${SMARTMETER_DIRECTORY}.tar.gz
ENV SMARTMETER_PATH /srv/var/${SMARTMETER_DIRECTORY}/sm-linux-light-full-${SMARTMETER_VERSION}/

# dependency env
ENV MVN_REPOSITORY http://central.maven.org/maven2/org/
ENV ELASTICSEARCH_VERSION 1.5.2
ENV ELASTICSEARCH_LINK ${MVN_REPOSITORY}elasticsearch/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.jar
ENV LUCENE_CORE_VERSION 4.10.4
ENV LUCENE_COMMON_ANALYZERS 4.10.4

# Automagically accept Oracle's license (for oracle-java8-installer)
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --force-yes oracle-java8-installer unzip && \

    # install smartmeter
    mkdir -p /srv/var/${SMARTMETER_DIRECTORY} && cd /srv/var/${SMARTMETER_DIRECTORY} && \
    wget ${SMARTMETER_URL} && \
    tar -zxf ${SMARTMETER_DIRECTORY}.tar.gz && rm ${SMARTMETER_DIRECTORY}.tar.gz && \

    # install elasticsearch and lucene
    cd ${SMARTMETER_PATH}programs/apache-jmeter/lib && \
    wget http://central.maven.org/maven2/org/elasticsearch/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.jar &&\
    wget http://central.maven.org/maven2/org/apache/lucene/lucene-core/${LUCENE_CORE_VERSION}/lucene-core-${LUCENE_CORE_VERSION}.jar && \
    wget http://central.maven.org/maven2/org/apache/lucene/lucene-analyzers-common/${LUCENE_COMMON_ANALYZERS}/lucene-analyzers-common-${LUCENE_COMMON_ANALYZERS}.jar

# Add ElasticSearchBackendListener
ADD smartmeter-elasticsearch.jar ${SMARTMETER_PATH}programs/apache-jmeter/lib/ext/

