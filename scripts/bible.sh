#!/usr/bin/env bash
# chapter=${1:?"give a chapter number"}
chapter=5

curl "https://bible-go-api.rkeplin.com/v1/books/43/chapters/${chapter}?translation=esv" \
  | jq -r ' .[] | .verse'
