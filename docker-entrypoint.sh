#!/bin/bash

set -e

# prepare router.ini
if [ "$REPLICATION" = "true" ] && [ ! -f /root/router.ini ]; then
	# get linked master's ip adress
	master=$(printenv | grep 'MYSQL_MASTER.*_TCP=' | awk 'BEGIN { FS="=" } ; {print $2}' | awk 'BEGIN { FS="://"} ; { print $2 }' | sort | uniq)

	# get linked slaves' ip adresses
	slaves=$(printenv | grep 'MYSQL_SLAVE.*_TCP=' | awk 'BEGIN { FS="=" } ; {print $2}' | awk 'BEGIN { FS="://"   } ; {print $2}' | sort | uniq)
	slave_destinations=$(echo $slaves | tr " " ",")

	if [ -z "$master" ] && [ -z "$slave_destinations"  ]; then
		echo "PLEASE LINK MYSQL CONTAINER WITH mysql_master or mysql_slave NAMES"
		exit 1
	fi

	cat >> /root/router.ini <<-EOL
	[routing:master]
	bind_address = 0.0.0.0:7001
	mode = read-write
	destinations = $master
	EOL

	cat >> /root/router.ini <<-EOL
	[routing:slaves]
	bind_address = 0.0.0.0:7002
	mode = read-only
	destinations = $slave_destinations
	EOL
fi

exec "$@"
