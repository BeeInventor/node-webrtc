#!/bin/bash

# build
VERSION=$(node -e "console.log(require('./package.json').version)")
docker build -t beeinventor/node-webrtc:latest-scratch -t "beeinventor/node-webrtc:$VERSION-scratch" .
