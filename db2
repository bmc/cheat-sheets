Instantiating an I-Accel database instance on Windows DB2

- Create a Windows user called "iaccel" and assign it a password.
  The user doesn't need to have administrator privileges. (This is the
  simplest way to get an "iaccel" user in DB2.)

- Using the Control Center, drill down to the Databases folder and
  create a new database. I'll call it "iaccel".

- Next, select the new "iaccel" database from the Control Center's explorer
  view.

- Go to the "Buffer Pools" item, right click on it, and select "Create".
  Give it a name. (I used "IACCEL".) Then, choose a page size of 8 or
  16. (I used 16.)

- Go to the Table Spaces item, right click on it, and select
  "Create > Table Space ...". (I didn't use the wizard.)

- Give the table space a name. (Again, I used "IACCEL".) Add a container
  for it. Basically, this is just a file in some directory on a drive that
  has enough space. For "Type of table space", it's okay to leave the
  selection as the default, which is "Regular".

- After adding the container, select the Advanced button on the bottom of
  the dialog.

- In the resulting pop-up, at the bottom, select the "IACCEL" buffer
  pool you created earlier.

- At the top of the dialog, select the same page size you use with the
  table space. (I used 16.)

- Click OK on the Advanced popup.

- Click OK on Create Table Space popup.

- Next, you have to give the IACCEL user permission to use the table space.
  You can do that one of three ways:

  a) Left click on Table Spaces in the explorer view. The IACCEL table
     space will show up in the right pane. Right click on the IACCEL table
     space. Select "Privileges". Select Add User in the popup, and add the
     "IACCEL" user. Then, select IACCEL from the list and select "Yes"
     from the "Privileges" drop-down list at the bottom of the dialog.

  b) Drill down to "User and Group Objects > DB Users". The list of users
     will show up in the right pane. Right click on IACCEL, and select
     "Change...". Select the "Table Spaces" tab, then proceed as in (a).

  c) Establish a query command-line with the database. You can either use
     the Command Tool that comes with the Windows DB2 installation, or you
     can use our "sqlcmd" tool. (If you use "sqlcmd", log in as "db2admin"
     with password "db2admin".) Then, issue this command:

	   grant use of tablespace iaccel to iaccel;

- Using the above procedure, also create a system table space with the same
  page size. However, it's not necessary (or even possible) to grant access
  to that table space per user. Just creating the table space within the
  database, and associating it with the right buffer pool, is sufficient.
  Without the system table space, certain complex queries will fail.

At this point, you should be able to use our "sqlcmd" tool (even remotely)
to connect to the DB2 database as user "iaccel", and "iaccel" should have
sufficient privileges to create the larger tables we require.

Setting up Text Extender

http://iacceldev.fulltiltinc.com/mailing-lists/iacceldev/2004-03/msg00349.html
