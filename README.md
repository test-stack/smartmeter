# Unofficial Docker Smartmeter 1.1.0 image
[Smartmeter](https://www.smartmeter.io/) is very powerfull aplication for Performance testing

This image is usefull for CI, CD and QA team, because enabling very quickly perform [Performance testing](https://en.wikipedia.org/wiki/Software_performance_testing)

## Docker image contains

* Smartmeter 1.1.0 [Changelog](https://www.smartmeter.io/documentation#toc-changelog)
* smartmeter-elasticsearch.jar ( ElasticSearchBackendListenerClient ) for sending results of samples to Elasticsearch
* elasticsearch.jar 1.5.2
* lucene_core.jar 4.10.4
* lucene_common_analyzers.jar 4.10.4

![Smartmeter](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/smartmeterDashboard.png)

## How to use

1a). pull image from Docker repository
```
docker pull rdpanek/smartmeter:1.1.0
- or -
docker pull rdpanek/smartmeter:latest
```

1b). pull git repository (it's recommended)
```
git pull https://github.com/test-stack/smartmeter
```

2). create `/custom` folders for dataproviders, smartmeter.properties, license and other files attached in test plan

3). create custom TestPlan.jmx at downloaded git repository

Example:

```
git pull https://github.com/test-stack/smartmeter
- smartmeter
  + custom/
  + docs/
  + Dockerfile
  + Makefile
  + Readme.md
  + TestPlan.jmx
  + smartmeter-elasticsearch.jar
  + smartmeterElasticMapping.txt


```

4a). run with params
```
docker run --rm --name smartmeter -v `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/tests/ -v `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/logs/ -v `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/results/ -v `pwd`/custom/:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/custom/ rdpanek/smartmeter:1.1.0 TestPlan.jmx
```

4b). or via Makefile
```
make run TestPlan.jmx
```

During a test launch, you can see

```
SmartMeter +      9 in  25.4s =    0.4/s Avg:  1399 Min:    72 Max:  3724 Err:     0 (0.00%) Active: 2 Started: 2 Finished: 0
SmartMeter +     29 in  27.3s =    1.1/s Avg:  2240 Min:    73 Max: 10375 Err:     0 (0.00%) Active: 5 Started: 5 Finished: 0
SmartMeter =     38 in    53s =    0.7/s Avg:  2041 Min:    72 Max: 10375 Err:     0 (0.00%)
```

After end of test will be container removed.

## Results

After running were created additional files in our `smartmeter` directory.

```
- smartmeter
  + launcher.log
  + controller.log
  + *.jtl
```

* controller.log is usefull for debbuging
* *.jtl is usefull for parsing via [Logstash](https://www.elastic.co/products/logstash) or [nxlog](http://nxlog.org/) or for generate [html report](http://rdpanek.cz/report-20160301-002656/)

For generate .jtl you must add `et@sm - Controller Summary Report` Listener.
![et@sm - Controller Summary Report](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/controllerSummaryReport.png)


## Setup Test Plan for support of Elasticserach

For real-time view on performance test, you cau use [Elasticsearch](https://www.elastic.co/) and [Kibana](https://www.elastic.co/products/kibana) or [Grafana](http://grafana.org/).
Actually is supported Elasticsearch 1.5.2 - development of supporting Elasticsearch 2.x is in progress.
Name of cluster must be `elasticsearch`.

For sending data to Elasticsearch you must added BackendListener `ElasticSearchBackendListenerClient` with options
* `elasticsearchCluster` is ip your Elasticsearch cluster, format: `ip:9300`
* `indexName` smartmeter
* `sampleType` smartmeter

![ElasticSearchBackendListenerClient](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/elasticsearchBackendListener.png)

### ElasticSearchBackendListenerClient JSON Payload

```json
{
    "ContentType": "application/json; charset=utf-8",
    "EndTime": "2016-02-29T19:36:32.032Z",
    "IdleTime": 0,
    "ElapsedTime": 136,
    "ErrorCount": 0,
    "Success": "true",
    "URL": "http://xxx.xxx.xxx.xxx:4444/wd/hub/session/4ae60744-e660-44f8-bf3b-cd7628e46713",
    "Bytes": 423,
    "AllThreads": 10,
    "NormalizedTimestamp": "2015-01-01T00:06:05.651Z",
    "DataType": "text",
    "ResponseTime": 136,
    "SampleCount": 1,
    "ConnectTime": 0,
    "RunId": "fe2bd84c-1877-4e2d-a789-fa83ddd1e7b8",
    "timestamp": "2016-02-29T19:36:31.896Z",
    "ResponseCode": "200",
    "StartTime": "2016-02-29T19:36:31.896Z",
    "ResponseMessage": "OK",
    "Assertions": [
        {
            "FailureMessage": "",
            "Failure": false,
            "Name": "sessionId Assertion"
        }
    ],
    "Latency": 136,
    "GrpThreads": 10,
    "BodySize": 159,
    "ThreadName": "VU 1-3",
    "SampleLabel": "Delete browser instance"
}

```

## Setup Elasticsearch

Create `smartmeter` template

```
# PUT http://xxx.xxx.xxx.xxx:9200/_template/smartmeter
{
    "template": "smartmeter-*",
    "mappings": {
        "smartmeter": {
            "dynamic": "strict",
            "properties": {
                "AllThreads": {
                    "type": "long"
                },
                "Assertions": {
                    "properties": {
                        "Failure": {
                            "type": "boolean"
                        },
                        "FailureMessage": {
                            "type": "string",
                            "index": "not_analyzed"
                        },
                        "Name": {
                            "type": "string",
                            "index": "not_analyzed"
                        }
                    }
                },
                "BodySize": {
                    "type": "long"
                },
                "Bytes": {
                    "type": "long"
                },
                "ConnectTime": {
                    "type": "long"
                },
                "ContentType": {
                    "type": "string"
                },
                "DataType": {
                    "type": "string"
                },
                "ElapsedTime": {
                    "type": "long"
                },
                "EndTime": {
                    "type": "date",
                    "format": "dateOptionalTime"
                },
                "ErrorCount": {
                    "type": "long"
                },
                "GrpThreads": {
                    "type": "long"
                },
                "IdleTime": {
                    "type": "long"
                },
                "Latency": {
                    "type": "long"
                },
                "NormalizedTimestamp": {
                    "type": "date",
                    "format": "dateOptionalTime"
                },
                "ResponseCode": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "ResponseMessage": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "ResponseTime": {
                    "type": "long"
                },
                "RunId": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "SampleCount": {
                    "type": "long"
                },
                "SampleLabel": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "StartTime": {
                    "type": "date",
                    "format": "dateOptionalTime"
                },
                "Success": {
                    "type": "string"
                },
                "ThreadName": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "URL": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "timestamp": {
                    "type": "date",
                    "format": "dateOptionalTime"
                }
            }
        }
    }
}
```

Check successfully template was added

```
# GET http://xxx.xxx.xxx.xxx:9200/_template

{
  "smartmeter": {
    "order": 0,
    "template": "smartmeter-*",
    "settings": {},
    "mappings": {
      "smartmeter": {
        "dynamic": "strict"
  ...
```

Check our Kibana
![Kibana](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/kibana.png)

**Congratulations, let's run performance tests** | Less code more tests