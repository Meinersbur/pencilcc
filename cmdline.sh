#!/bin/bash 
i=1
for arg in "$@"; do
  echo "\$${i}=${arg}"
  ((i++))
done
