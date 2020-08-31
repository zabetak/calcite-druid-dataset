# Druid Calcite Adapter IT Setup

Dockerized Druid setup for running Calcite's
[Druid adapter](https://github.com/apache/calcite/tree/master/druid)
integration tests.

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Bash](https://www.gnu.org/software/bash/)

## Instructions

* Create and start the Druid containers: `docker-compose up`
* Verify Druid is up and running by visiting Druid's [console](http://localhost:8888/unified-console.html)
* Load foodmart and wikipedia datasets in Druid: `./index.sh`; indexing may take a few seconds so be patient
* Verify datasets are loaded by visiting Druid's [datasources](http://localhost:8888/unified-console.html#datasources); foodmart and wikipedia should be present
* Destroy the Druid containers and volumes: `docker-compose down -v`
* Cleanup data and logs in storage directory: `git clean -df`
