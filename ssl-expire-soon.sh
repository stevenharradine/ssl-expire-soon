#!/usr/bin/env bash

source ./domains.sh

for DOMAIN in "${DOMAINS[@]}"
do
 expire_in_seconds=$(($(date --date="$(openssl s_client -connect $DOMAIN:443 < /dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | awk -F\= '{print $2}')" +%s)-$(date +%s)))
 expire_in_days=`expr $expire_in_seconds / 60 / 60 / 24`
 
 if [ $expire_in_days -le 30 ]; then
  echo -n "*"
 else
  echo -n " "
 fi

 echo "$expire_in_days $DOMAIN"
done

