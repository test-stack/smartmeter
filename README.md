# Unofficial Docker SmartMeter_1.3.0-SNAPSHOT-161104-1714_L_Light image
[Smartmeter](https://www.smartmeter.io/) is very powerfull aplication for Performance testing

This image is usefull for CI, CD and QA team, because enabling very quickly perform [Performance testing](https://en.wikipedia.org/wiki/Software_performance_testing)

## Docker image contains

* SmartMeter 1.3.0 [Changelog](http://smartmeter-api.etnetera.cz/download/nightly/CHANGELOG.html)
* [ElasticSearchBackendListenerClient.jar](https://github.com/test-stack/elasticSearchBackendListenerClient)

![Smartmeter](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/smartmeterDashboard.png)

## ElasticSearchBackendListenerClient Plugin

Sending data to Elasticsearch for analysis - [how to install](https://github.com/test-stack/elasticSearchBackendListenerClient)

## How to use

1a). pull image from Docker repository
```
docker pull rdpanek/smartmeter:1.3.0
```

1b). pull git repository (it's recommended)
```
git pull https://github.com/test-stack/smartmeter
```

2). update `/custom/smartmeter.properties` and add license.bin

3). create custom TestPlan.jmx and add to `tests` directory

Example:

```
git pull https://github.com/test-stack/smartmeter
- smartmeter
  + custom/
  + docs/
  + TestPlan.jmx
  + Dockerfile
  + Makefile
  + Readme.md


```

4a). run with params
```
docker run --rm --name smartmeter -v
 `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/tests/ -v
 `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/logs/ -v
 `pwd`:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/results/ -v
 `pwd`/custom/:/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/custom/ rdpanek/smartmeter:latest TestPlan.jmx
```

4b). or via Makefile
```
make run TestPlan.jmx
```

After a test launch, you can see

```
SmartMeter +      9 in  25.4s =    0.4/s Avg:  1399 Min:    72 Max:  3724 Err:     0 (0.00%) Active: 2 Started: 2 Finished: 0
SmartMeter +     29 in  27.3s =    1.1/s Avg:  2240 Min:    73 Max: 10375 Err:     0 (0.00%) Active: 5 Started: 5 Finished: 0
SmartMeter =     38 in    53s =    0.7/s Avg:  2041 Min:    72 Max: 10375 Err:     0 (0.00%)
```

Container will be removed after end of test.

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
# PUT http://xxx.xxx.xxx.xxx:9200/_template/smartmeterv2
{
    "template": "smartmeterv2-*",
    "mappings": {
        "smartmeterv2": {
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
                            "type": "text",
                            "index": true
                        },
                        "Name": {
                            "type": "text",
                            "index": true
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
                    "type": "text"
                },
                "DataType": {
                    "type": "text"
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
                    "type": "keyword",
                    "index": true
                },
                "ResponseMessage": {
                    "type": "text",
                    "index": true
                },
                "ResponseTime": {
                    "type": "long"
                },
                "RunId": {
                    "type": "keyword",
                    "index": true
                },
                "SampleCount": {
                    "type": "long"
                },
                "SampleLabel": {
                    "type": "keyword",
                    "index": true
                },
                "StartTime": {
                    "type": "date",
                    "format": "dateOptionalTime"
                },
                "Success": {
                    "type": "keyword"
                },
                "ThreadName": {
                    "type": "keyword",
                    "index": true
                },
                "URL": {
                    "type": "keyword",
                    "index": true
                },
                "timestamp": {
                    "type": "date",
                    "format": "dateOptionalTime"
                },
                "release": {
                    "type": "keyword",
                    "index": true
                },
                "testPlanName": {
                    "type": "keyword",
                    "index": true
                },
                "RequestHeaders": {
                    "type": "text",
                    "index": true
                },
                "ResponseData": {
                    "type": "text",
                    "index": false
                },
                "DataEncoding": {
                    "type": "keyword",
                    "index": false
                },
                "SamplerData": {
                    "type": "text",
                    "index": true
                },
                "SubResults": {
                    "type": "text",
                    "index": true
                },
                "verbose": {
                    "type": "keyword",
                    "index": false
                },
                "flag": {
                    "type": "keyword",
                    "index": true
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
    "template": "smartmeterv2-*",
    "settings": {},
    "mappings": {
      "smartmeter": {
        "dynamic": "strict"
  ...
```

Check Kibana
![Kibana](https://raw.githubusercontent.com/test-stack/smartmeter/master/docs/kibana.png)

**Congratulations, let's run performance tests** | Less code more tests
