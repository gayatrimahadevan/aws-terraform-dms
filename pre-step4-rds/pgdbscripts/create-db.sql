CREATE DATABASE demodb;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE demodb FROM PUBLIC;
CREATE ROLE ebreadonly;
GRANT CONNECT ON DATABASE demodb TO ebreadonly;
CREATE ROLE ebreadwrite;
GRANT CONNECT ON DATABASE demodb TO ebreadwrite;
CREATE USER reportuser WITH PASSWORD 'password01';
GRANT ebreadonly TO reportuser;
CREATE USER appuser WITH PASSWORD 'password02';
GRANT ebreadwrite TO appuser;
\c demodb
DROP SCHEMA public;
\c postgres
ALTER DATABASE demodb OWNER TO appuser;
\c postgresql://appuser:password02@db-ebportal.cs46pp7ymrlq.us-east-1.rds.amazonaws.com/demodb
CREATE SCHEMA scott;
GRANT USAGE ON SCHEMA scott TO ebreadonly;
GRANT USAGE,CREATE ON SCHEMA scott TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT SELECT,UPDATE,DELETE,INSERT ON TABLES TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT USAGE ON SEQUENCES TO ebreadwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT SELECT ON TABLES TO ebreadonly;
ALTER DATABASE demodb SET SEARCH_PATH TO scott;
