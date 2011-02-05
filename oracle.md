title: Oracle Cheat Sheet

## Getting a list of indexes

The query

    SELECT INDEX_NAME FROM DBA_INDEXES

will list the names of all non-system indexes. Also, from
<http://technet.oracle.com/docs/products/oracle8i/doc_index.htm>

> System index views USER_INDEXES, ALL_INDEXES, and DBA_INDEXES indicate
> bitmap indexes by the word BITMAP appearing in the TYPE column. A bitmap
> index cannot be declared as UNIQUE.

Must have system privileges to issue the query.

## Getting a cross-reference of tables and their indexes

    SELECT table_name, index_name FROM dba_indexes WHERE table_name = 'TABLENAME'

Must have system privileges to issue the query.

## Determining the indexes on a table

### Getting the names of indexes for a table

    SELECT INDEX_NAME name FROM USER_INDEXES
    WHERE TABLE_NAME = 'table_name' AND GENERATED = 'N';

## Determining the columns on which an index is based:

    SELECT aic.index_name,
              aic.column_name,
              aic.column_position,
              aic.descend,
              aic.table_owner,
              CASE alc.constraint_type
                WHEN 'U' THEN 'UNIQUE'
                WHEN 'P' THEN 'PRIMARY KEY'
                ELSE ''
              END AS index_type
         FROM all_ind_columns aic
    LEFT JOIN all_constraints alc
           ON aic.index_name = alc.constraint_name
          AND aic.table_name = alc.table_name
          AND aic.table_owner = alc.owner
        WHERE aic.table_name = 'TEST2'            -- table name
        --AND aic.table_owner = 'HR'              -- table owner
        --AND aic.index_name = 'TEST2_FIELD5_IDX' -- index name
     ORDER BY column_position;

## Other useful metadata queries

See <http://www.alberton.info/oracle_meta_info.html>

## Creating a user

In SQL*Plus, connect as `SYSTEM/MANAGER@dbname`. Then, issue the following
SQL:

    CREATE USER user IDENTIFIED BY password
    DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

For example:

    CREATE USER user1 IDENTIFIED BY mypassword
    DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

Next, grant appropriate privileges to the new user:

    GRANT connect, resource TO user1;

In SQL*Plus, connect as `user1/mypassword@dbname`. Create tables, indexes,
etc... They'll be owned by the new user.

## Changing user's password

    ALTER USER user IDENTIFIED BY password

## Sharing tables between two users

Create a second user, *user2*. (See above) Then, connect as *user1*, and
issue this command:

    GRANT insert, update, delete, select on user1.table1 TO user2;

Do this for all appropriate tables/indexes.

Now, if *user2* logs in, he can access `user1.table1`, but he must
refer to it as `user1.table1`. You can create a public synonym for
the table to make this easier. See below.

## Creating a public synonym for a table

Log in as the table's owner (*user1*, in this example), and issue this SQL:

     CREATE PUBLIC SYNONYM table1 FOR user1.table1

## Granting DBA privileges to a user

In a word: Don't. Instead, grant the appropriate privileges on the
appropriate tables to an unprivileged user.

## Creating a rollback segment:

Connect as `SYSTEM/MANAGER`, then:

    CREATE ROLLBACK SEGMENT segname TABLESPACE USERS;

Then, add the rollback segment name to the `initXXX.ora` file for the
instance.

## If database is hung shutting down or starting up

As Oracle user:

    $ svrmgrl
    Oracle8i Enterprise Edition Release 8.1.5.0.2 - Production
    With the Partitioning and Java options
    PL/SQL Release 8.1.5.0.0 - Production

    SVRMGR> connect internal
    SVRMGR> shutdown
    SVRMGR> startup force
    SVRMGR> ^D

If that fails, try killing the Oracle processes. Then, since Oracle uses
two of the "three evil sisters", semaphores and shared memory, "ipcrm" the
Oracle-owned one after the "kill -9" and it should restart.

## Dumping and Restoring an Oracle Database

### Dump:

    sqlplus system/manager <<EOF
    grant dba to user1;
    EOF

    exp user1/password@instance # accept defaults, except for "Export entire
                                # database". Choose "1" for that.

When prompted with 

    (1)E(ntire database), (2)U(sers), or (3)T(ables): (2)U >

accept the default ("U"), and enter the appropriate user name (i.e., the
owner of the tables) when prompted.

    sqlplus system/manager <<EOF
    revoke dba from user1;
    EOF

### Restore

Drop all existing tables and indexes in same db first.

    sqlplus system/manager <<EOF
    grant dba to user1;
    EOF

    imp user1/password@instance

    sqlplus system/manager <<EOF
    revoke dba from user1;
    EOF

May have to restore SYSTEM account's password afterwards.

## Oracle 9.2.0 Intermedia Problems:

### CTX_DDL must be declared

If this error occurs:

    PLS-00201: identifier 'CTX_DDL' must be declared

then the user doesn't have appropriate privileges. This seems to cure the
problem:

    sqlplus system/manager@instance <<EOF
    grant ctxapp to user1
    EOF

### Error during stored procedure definition

If the above error occurs during definition of a stored procedure, then:

    sqlplus system/manager@instance <<EOF
    grant create any procedure to user1
    EOF

### "Insufficient privilege" error

If you THEN get:

    PLS-00904: insufficient privilege to access object CTXSYS.CTX_DDL

try:

    sqlplus system/manager@instance <<EOF
    grant execute on CTXSYS.CTX_DDL to user1;
    EOF

## EXPLAIN PLAN and Autotrace

Create the relevant tables in the schema, e.g.:

    sqlplus user1/password@instance @$ORACLE_HOME/rdbms/admin/utlxplan.sql

Create the `PLUSTRACE` role, etc.:

    sqlplus /nolog <<EOF
    connect / as sysdba
    @$ORACLE_HOME/sqlplus/admin/plustrce.sql
    EOF

Grant the `PLUSTRACE` role to the user who owns the DB:

    sqlplus system/manager@instance <<EOF
    grant plustrace to user1;
    EOF

Can now run EXPLAIN PLAN (see Oracle docs) or autotrace.

    sqlplus user1/password@instance
    SQL> set autotrace trace|on|off
    SQL> <statement(s)>

* "trace" says to run the statement(s) and print the plan(s), but avoid
  displaying any results.
* "on" prints the plan(s) and the results.

## Managing statistics for the cost-based optimizer

Creating statistics for the cost-based optimizer

    sqlplus system/manager@instance <<EOF
    EXEC DBMS_UTILITY.analyze_schema('IACCEL', 'COMPUTE')
    EOF

Deleting those statistics:

    sqlplus system/manager@instance <<EOF
    EXEC DBMS_UTILITY.analyze_schema('IACCEL', 'DELETE')
    EOF

## After bringing up database, can't connect via SQL*Plus.

Try waiting a minute or two.
