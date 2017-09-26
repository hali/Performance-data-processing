/** Run this script as a user who have permissions to create other users and give permissions to them.
	Please note, that if you change the name of the schema, you will need to update it:
		- In all SQL scripts you use.
		- In rhapsody variables manager - Dataprofile_db_name variable.
		- In rhapsody, for every Database Lookup component in the datapot routes - edit 
			configuration and enter a new schema name in the Database Connection component.
*/
CREATE USER datapot IDENTIFIED BY "password";

GRANT CREATE SESSION TO datapot;
GRANT RESOURCE TO datapot;
GRANT UNLIMITED TABLESPACE TO datapot;
GRANT 	CREATE SEQUENCE	 TO datapot;
GRANT 	CREATE TABLE	 TO datapot;