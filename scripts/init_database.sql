/*
=============================================================
Create Database 
=============================================================
Script Purpose:
    This script creates a three new databases named 'bronze', 'silver', and 'gold' after checking if it already exists. 
	
WARNING:
    Running this script will drop the entire database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Create Databases
DROP DATABASE IF EXISTS bronze;
CREATE DATABASE bronze;

DROP DATABASE IF EXISTS silver;
CREATE DATABASE silver;

DROP DATABASE IF EXISTS gold;
CREATE DATABASE gold;
