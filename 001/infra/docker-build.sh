#!/bin/bash
. .env

docker build \
  -t study-infra-tf:${IMAGE_VERSION} \
  --build-arg AWS_ACCESS_KEY=${AWS_ACCESS_KEY} \
  --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  --build-arg ENV=${ENV} \
  .
