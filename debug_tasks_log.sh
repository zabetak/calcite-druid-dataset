#!/usr/bin/env bash

while true
do
  while read -r taskid
  do
    echo
    echo "Log for task with id=$taskid"
    echo
    curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/task/$taskid/log
    echo
  done < <(curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/tasks | sed 's/\[{"id":"\([^"]\+\)".*/\1\n/')
  echo
  echo "Complete Tasks:"
  echo
  curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/completeTasks
  echo
  echo "Running Tasks:"
  echo
  curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/runningTasks
  echo
  echo "Waiting Tasks:"
  echo
  curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/waitingTasks
  echo
  echo "Pending Tasks:"
  echo
  curl -s -X 'GET' 0.0.0.0:8081/druid/indexer/v1/pendingTasks
  echo
  sleep 10s
done
