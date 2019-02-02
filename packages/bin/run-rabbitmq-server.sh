#!/bin/bash

# Setup environment variables
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export HOME="/var/lib/rabbitmq"
export targethost=`hostname`
export targetip=`hostname -i`

echo -e "$targethost\n$targetip" > /var/log/rabbitmq/rmq_host.txt
echo "$(date +'%Y-%m-%d %H:%M:%S:%3N')" >> /var/log/rabbitmq/rmq_host.txt

# Check for rabbitmq cookie
if [ "${RABBITMQ_ERLANG_COOKIE:-}" ]; then
	cookieFile='/var/lib/rabbitmq/.erlang.cookie'
	if [ -e "$cookieFile" ]; then
		if [ "$(cat "$cookieFile" 2>/dev/null)" != "$RABBITMQ_ERLANG_COOKIE" ]; then
			echo >&2
			echo >&2 "warning: $cookieFile contents do not match RABBITMQ_ERLANG_COOKIE"
			echo >&2
		fi
	else
		echo "$RABBITMQ_ERLANG_COOKIE" > "$cookieFile"
	fi
	chmod 600 "$cookieFile"
fi

#Startup RabbitMQ services
exec /usr/sbin/rabbitmq-server
