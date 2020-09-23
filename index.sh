#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to you under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if [ $# -gt 1 ]
  then
    echo "Wrong number of arguments"
    echo "Usage: index.sh [INDEX_POLL_DELAY]"
    echo "INDEX_POLL_DELAY: Optional argument specifying the delay that we poll the logs to check if indexing is finished."
    exit 1
fi

# If not arguments are provide the default delay to poll the logs is 1 second
sleep_delay=1s
if [ $# -eq 1 ]
  then
    sleep_delay=$1
fi

# Change coordinator rules to not replicate datasets
curl -H "Content-Type: application/json" -X POST -d '[{"tieredReplicants":{"_default_tier":1},"type":"loadForever"}]' 0.0.0.0:8081/druid/coordinator/v1/rules/_default

# Start task to index the foodmart data set
echo 'Indexing foodmart dataset...'
curl -X 'POST' -H 'Content-Type:application/json' -d @schemas/foodmart-index.json 0.0.0.0:8081/druid/indexer/v1/task
# Wait till the 12 segments of the dataset are completely loaded
until [ 12 -eq `docker logs historical | grep "LOAD: foodmart_" | wc -l` ] ; do sleep $sleep_delay; done

echo 'Indexing wikipedia dataset...'
curl -X 'POST' -H 'Content-Type:application/json' -d @schemas/wikipedia-index.json 0.0.0.0:8081/druid/indexer/v1/task
# Wait till the 24 segments of the dataset are completely loaded
until [ 24 -eq `docker logs historical | grep "LOAD: wikipedia_" | wc -l` ] ; do sleep $sleep_delay; done
