#!/bin/bash

rm -f /pgconf/setup.sql /pgconf/grants.sql
curl https://raw.githubusercontent.com/sogis/oereb-db/master/sql/setup_original.sql > /pgconf/setup_original.sql
curl https://raw.githubusercontent.com/sogis/oereb-db/master/sql/set_role.sql > /pgconf/set_role.sql
cat /pgconf/setup_original.sql /pgconf/set_role.sql > /pgconf/setup.sql
# Hack/unnecessary but required command (PG_WRITE_USER does not exist yet):
sed -i s/:PG_WRITE_USER/${PG_USER}/g /pgconf/setup.sql

echo "CREATE USER :PG_WRITE_USER WITH PASSWORD :'PG_WRITE_PASSWORD';ALTER USER admin WITH SUPERUSER;" > /pgconf/grants.sql

exec "$@"
