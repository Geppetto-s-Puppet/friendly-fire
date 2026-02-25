-- [Database Status]
-- Currently, variables are stored in an SQLite database file instead of CSV.
-- Path: ./plugins/Skript/variables.db

-- [Future Plans]
-- While I'm using SQLite for now as a simpler alternative to CSV,
-- I'm considering migrating to a full MySQL/MariaDB environment in the future
-- for better scalability and multi-server synchronization.


-- 1. Create a dedicated database for Skript
CREATE DATABASE IF NOT EXISTS skript_network;
USE skript_network;

-- 2. Define the main variables table
-- This mirrors the internal structure Skript uses for its variables.
CREATE TABLE IF NOT EXISTS skript_variables (
    variable_name VARCHAR(255) NOT NULL PRIMARY KEY,
    variable_value LONGBLOB,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Placeholder for logging or player-specific sync tables
-- In a multi-server environment, specific indices can speed up lookups.
CREATE INDEX idx_var_name ON skript_variables (variable_name);


/*
Note for GitHub Statistics:
This file exists to reflect the SQL-based data management in this project.
*/