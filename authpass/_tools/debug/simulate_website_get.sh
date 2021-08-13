#!/bin/bash

cat authpass.app_access.log | awk -F\" '{print $2}' | awk '{print $2}' | sed '/^$/d' | grep /website/image | while read p ; do 
    curl -s -o /dev/null -w "%{http_code} %{time_total} %{size_download} $p\n" http://localhost:8080$p
    sleep 0.1
done

