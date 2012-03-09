#!/bin/bash
cat <<EOL

###############################################################################

  This is a simple program to confirm Varnish cache HITS.
  NOTE: It attempts to warm the cache and can take a few minutes to run.

###############################################################################

EOL

URLS=(`cat urls.txt`)

HITS=0
MISSES=0

for url in "${URLS[@]}"
do
  #warm cache
  $(curl -s $url 2>&1 >/dev/null)

  #grab HIT|MISS and trim
  RESULT="$(curl -sI $url 2>&1 | grep 'X-Varnish-Cache')"
  RESULT=$(echo ${RESULT:17})
  RESULT=$(echo ${RESULT%?})

  printf "%s %s" $url $RESULT
  #report misses
  if [ "$RESULT" == "MISS" ]
  then
    MISSED_URLS+=("$url")
    MISSES=$(expr $MISSES + 1)
  else
    HITS=$(expr $HITS + 1)
  fi
done

  #simple summary
  printf "%d HITS\n" $HITS
  printf "%d MISSES\n" $MISSES
  cat <<EOL
=====================================MISSES=====================================

EOL
  
for missed in "${MISSED_URLS[@]}"
do
  printf "MISSED %s \n" $missed
done

  cat <<EOL

================================================================================
EOL
