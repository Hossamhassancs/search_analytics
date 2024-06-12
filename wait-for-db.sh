#!/bin/bash
set -e

until pg_isready -h db -p 5432 -U postgres; do
  echo >&2 "Postgres is unavailable - sleeping"
  sleep 1
done

echo >&2 "Postgres is up - executing command"
exec "$@"
