#!/bin/bash

cat <<EOL

###############################################################################

  This is a simple program that runs Apache Benchmark on a small sample. It 
  is not meant to be comprehensive, but instead to provide a consistent test,
  so that any changes to the website or servers can be smoke-tested for major
  errors.
  
  FYI: this takes a few minutes to run.

###############################################################################

EOL

#array of URLs to benchmark
URLS=(`cat urls.txt`)

for url in "${URLS[@]}"
do
  #run ab on each URL: 500 reqs 15 at a time.  snip output
  printf "%s %s\n" $url "`ab -n 500 -c 15 $url 2>&1 | grep 'Requests per second:'`"
done

