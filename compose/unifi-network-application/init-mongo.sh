#!/bin/bash

# This file is source-d after MongoDB has started the first time
# that is we have access to all environment variables and functions
# of the startup script...
#
# Context used in this script is
#  $f        the path to this script
#  file_env  a function to resolve a VAR_FILE to VAR

__ENV_FILE__="$(dirname ${f})/.env"
if [ -r "${__ENV_FILE__}" ] ; then
  echo "Reading environment from ${__ENV_FILE__}"
  . "${__ENV_FILE__}"
else
  echo "Environment file ${__ENV_FILE__} does not exist"
  echo "Continuing with additional environment, script may fail"
fi

# Support reading Unifi user name and password from a file
file_env 'UNIFI_MONGO_USER'
file_env 'UNIFI_MONGO_PASS'

echo "Creating user ${UNIFI_MONGO_USER}"
_SCRIPT__="db.createUser({
	  user: \"${UNIFI_MONGO_USER}\",
	  pwd: \"${UNIFI_MONGO_PASS}\",
	  roles: [
		{
			role: \"dbOwner\",
			db: \"${UNIFI_MONGO_DBNAME}\"
		},
		{
			role: \"dbOwner\",
			db: \"${UNIFI_MONGO_DBNAME}_stat\"
		}
	]});"
"${mongo[@]}" "${UNIFI_MONGO_DBNAME}" --eval "${__SCRIPT__}"
