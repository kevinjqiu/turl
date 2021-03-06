#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $TURL_USER WITH PASSWORD '$TURL_DATABASE_PASSWORD' CREATEDB;
    CREATE DATABASE $TURL_DATABASE;
    GRANT ALL PRIVILEGES ON DATABASE $TURL_DATABASE TO $TURL_USER;
EOSQL
