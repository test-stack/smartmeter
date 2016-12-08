# Unofficial Docker SmartMeter_1.3.0-SNAPSHOT-161104-1714_L_Light image
[Smartmeter](https://www.smartmeter.io/) is very powerfull aplication for Performance testing

This image is usefull for CI, CD and QA team, because enabling very quickly perform [Performance testing](https://en.wikipedia.org/wiki/Software_performance_testing)

## Docker image contains

* SmartMeter 1.3.0 [Changelog](http://smartmeter-api.etnetera.cz/download/nightly/CHANGELOG.html)
* [ElasticSearchBackendListenerClient.jar](https://github.com/test-stack/elasticSearchBackendListenerClient) JMeter plugin

## How to use

1). pull git repository (it's recommended)
```
git pull https://github.com/test-stack/smartmeter


- smartmeter/
 + custom/
 + Dockerfile
 + docs/
 + kibanaDashboardsSmartmeter.json
 + kibanaVisualicationsSmartmeter.json
 + Makefile
 + README.md

```
2). add [license.bin](https://www.smartmeter.io/download#licence) to `/custom` directory

3). copy your TestPlan.jmx and dependencies to `/smartmeter`

4). run smartmeter via Docker
```bash
docker run --rm --name smartmeter -v `pwd`:/home/SmartMeter_1.3.0_linux/tests/ -v `pwd`:/home/SmartMeter_1.3.0_linux/logs/ -v `pwd`:/home/SmartMeter_1.3.0_linux/results/ -v `pwd`/custom/:/home/SmartMeter_1.3.0_linux/custom/ rdpanek/smartmeter:1.3.1 TestPlan.jmx

```
or

`make run TestPlan.jmx`

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

## Setup Test Plan for support of Elasticserach

![Smartmeter](https://raw.githubusercontent.com/test-stack/smartmeter/develop/docs/elasticSearchBackendListener.png)

  * `elasticsearchCluster` is target instance of Elasticsearch
  * `indexName` and `sampleType` only for experts
  * `runId` is ID of unique run
  * `release`, `testPlanName` and `flag` is a searchable labels
  * `verbose` options `always|ifError|never` logs of requests and response

Sends data to the Elasticsearch for analysis - [how to install](https://github.com/test-stack/elasticSearchBackendListenerClient)


For real-time view on performance test, you cau use [Elasticsearch](https://www.elastic.co/) and [Kibana](https://www.elastic.co/products/kibana) or [Grafana](http://grafana.org/).

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
  "smartmeterv2": {
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
