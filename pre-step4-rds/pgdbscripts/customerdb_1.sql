CREATE DATABASE customerdb;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE customerdb FROM PUBLIC;
CREATE ROLE customer_ro;
GRANT CONNECT ON DATABASE customerdb TO customer_ro;
CREATE ROLE customer_rw;
GRANT CONNECT ON DATABASE customerdb TO customer_rw;
CREATE USER customer_reportuser WITH PASSWORD 'password01';
GRANT customer_ro TO customer_reportuser;
CREATE USER customer_appuser WITH PASSWORD 'password02';
GRANT customer_rw TO customer_appuser;
\c customerdb
DROP SCHEMA public;
\c postgres
ALTER DATABASE customerdb OWNER TO customer_appuser;
\c postgresql://customer_appuser:password02@db-ebportal.cc9nuoyyzd1l.us-east-1.rds.amazonaws.com/customerdb
CREATE SCHEMA saleslt;
GRANT USAGE ON SCHEMA saleslt TO customer_ro;
GRANT USAGE,CREATE ON SCHEMA saleslt TO customer_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA saleslt GRANT SELECT,UPDATE,DELETE,INSERT ON TABLES TO customer_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA saleslt GRANT USAGE ON SEQUENCES TO customer_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA saleslt GRANT SELECT ON TABLES TO customer_ro;
ALTER DATABASE customerdb SET SEARCH_PATH TO saleslt;
