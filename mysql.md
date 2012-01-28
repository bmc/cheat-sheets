---
title: MySQL Cheat Sheet
layout: cheat-sheet
---

# Grant all privileges to a database

Prior to MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user @'%' IDENTIFIED BY 'db_passwd'; 

MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user IDENTIFIED BY 'db_passwd'; 

# Create a database

Using default system encoding:

    $ mysql -u root
    mysql> create database db_name;

Specifying encoding:

    $ mysql -u root
    mysql> create database db_name character set utf8;
