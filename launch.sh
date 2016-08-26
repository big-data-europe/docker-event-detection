#!/usr/bin/env bash
docker run -it  -v $(pwd)/mountdir:/mnt --net=host bdedeploy bash
