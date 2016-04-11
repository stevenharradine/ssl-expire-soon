#!/usr/bin/env bash

source ./domains.sh

for DOMAIN in "${DOMAINS[@]}"
do
# cert_expiry_date=$(openssl s_client -connect $DOMAIN:443 < /dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | awk -F\= '{print $2}')
 cert_expiry_date=`curl -v --silent https://$DOMAIN 2>&1 | grep "expire date:" | awk -F": " '{print $2}'`

 cert_expiry_epoc=$(date --date="$cert_expiry_date" +%s)
 now_epoc=$(date +%s)
 expire_in_seconds=$(($cert_expiry_epoc-$now_epoc))
 expire_in_days=`expr $expire_in_seconds / 60 / 60 / 24`
 valid_beyond_check_range=true

 if [ $expire_in_days -le $1 ]; then
  valid_beyond_check_range=false
 fi

 # if [ $valid_beyond_check_range = false ]; then
 #  echo -n "*"
 # else
 #  echo -n " "
 # fi
 # echo "$expire_in_days $DOMAIN"

 if [ $valid_beyond_check_range = false ]; then
  eval $2 $DOMAIN $expire_in_days
  buffered_slack="$buffered_slack\n$DOMAIN will expire in $expire_in_days days"
 fi
done

buffered_slack="$buffered_slack\nScan complete"
curl -X POST --data-urlencode "payload={\"username\": \"SSL Expire Soon\", \"text\": \"$buffered_slack\"}" https://hooks.slack.com/services/$3
