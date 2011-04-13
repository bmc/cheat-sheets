---
title: PostgreSQL Cheat Sheet
layout: cheat-sheet
---

# Initial user ID

Ubuntu (and maybe other Unices): Initial user is "postgres". Authentication
is defined in `pg_hba.conf` (`/etc/postgres/<version>`) and defaults to
`ident`. You can't fire up `psql` without proper auth.

* Leave configuration alone.
* "su" to the "postgres" user
* "psql" should then work

# Get list of databases

    SELECT datname FROM pg_database

# Give a user (role) superuser privilege

    ALTER ROLE username WITH superuser

# Load a CSV file

Load a CSV file (or some other kind of file) into PostgreSQL:

    COPY tablename FROM 'file.csv' CSV;

See <http://www.postgresql.org/docs/8.1/interactive/sql-copy.html>

