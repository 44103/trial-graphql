#!/bin/zsh

. ./api_conf.env

QUERY=$(sed -z 's/\n//g' $1)
QUERY=${QUERY//\"/\\\"}

curl -s -XPOST $API_ENDPOINT \
  -H "Content-Type: application/graphql" \
  -H "x-api-key: $API_KEY" \
  -d "{ \"query\": \"$QUERY\" }"
