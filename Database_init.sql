/*
 Script Purpose:
 This script create a new database named 'DataWareHouse' after checking if it already exists. 
 This script sets up three schemas within the database: bronze,silver and gold.
*/

-- Create Database
CREATE DATABASE DataWareHouse;

-- Initialize the database
Use DataWareHouse;


-- Creating the SCHEMA'S
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO