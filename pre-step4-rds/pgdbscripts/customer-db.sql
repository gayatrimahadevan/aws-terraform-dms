/*
CREATE DATABASE customerdb;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE customerdb FROM PUBLIC;
CREATE ROLE ebreadonly;
GRANT CONNECT ON DATABASE customerdb TO ebreadonly;
CREATE ROLE ebreadwrite;
GRANT CONNECT ON DATABASE customerdb TO ebreadwrite;
CREATE USER reportuser WITH PASSWORD 'password01';
GRANT ebreadonly TO reportuser;
CREATE USER appuser WITH PASSWORD 'password02';
GRANT ebreadwrite TO appuser;
\c customerdb
DROP SCHEMA public;
\c postgres
ALTER DATABASE customerdb OWNER TO appuser;
\c postgresql://appuser:password02@db-ebportal.cs46pp7ymrlq.us-east-1.rds.amazonaws.com/customerdb
*/
CREATE SCHEMA salesLT;
GRANT USAGE ON SCHEMA salesLT TO ebreadonly;
GRANT USAGE,CREATE ON SCHEMA salesLT TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA salesLT GRANT SELECT,UPDATE,DELETE,INSERT ON TABLES TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA salesLT GRANT USAGE ON SEQUENCES TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA salesLT GRANT SELECT ON TABLES TO ebreadonly;
ALTER DATABASE customerdb SET SEARCH_PATH TO salesLT;
