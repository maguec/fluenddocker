#!/bin/bash

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

if [[ -v BASE64_SERVICE_ACCOUNT ]]; then
	echo "# Setting up Service Account"
	echo $BASE64_SERVICE_ACCOUNT | base64 -d > /tmp/service_account.json
fi

if [[ -v BASE64_FLUENTD_CONFIG ]]; then
	echo "#####################################################################"
	echo "# Running with the following configuration "
	echo "#####################################################################"
	echo $BASE64_FLUENTD_CONFIG | base64 -d | tee /fluentd/etc/fluentd.conf
	echo "#####################################################################"
elif [[ -v FLUENTD_CONFIG ]]; then
	echo "#####################################################################"
	echo "# Running with the following configuration "
	echo "#####################################################################"
	echo $FLUENTD_CONFIG | tee /fluentd/etc/fluentd.conf
	echo "#####################################################################"
else 
	echo "Please set either BASE64_FLUENTD_CONFIG or FLUENTD_CONFIG ENV Vars"
	exit 2
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

/usr/local/bundle/bin/fluentd --config /fluentd/etc/fluentd.conf
