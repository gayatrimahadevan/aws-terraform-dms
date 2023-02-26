CREATE DATABASE empdb;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE empdb FROM PUBLIC;
CREATE ROLE emp_ro;
GRANT CONNECT ON DATABASE empdb TO emp_ro;
CREATE ROLE emp_rw;
GRANT CONNECT ON DATABASE empdb TO emp_rw;
CREATE USER emp_reportuser WITH PASSWORD 'password01';
GRANT emp_ro TO emp_reportuser;
CREATE USER emp_appuser WITH PASSWORD 'password02';
GRANT emp_rw TO emp_appuser;
\c empdb
DROP SCHEMA public;
\c postgres
ALTER DATABASE empdb OWNER TO emp_appuser;
\c postgresql://emp_appuser:password02@db-ebportal.cimx6fyo6eit.us-east-1.rds.amazonaws.com/empdb
CREATE SCHEMA scott;
GRANT USAGE ON SCHEMA scott TO emp_ro;
GRANT USAGE,CREATE ON SCHEMA scott TO emp_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT SELECT,UPDATE,DELETE,INSERT ON TABLES TO emp_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT USAGE ON SEQUENCES TO emp_rw;
ALTER DEFAULT PRIVILEGES IN SCHEMA scott GRANT SELECT ON TABLES TO emp_ro;
ALTER DATABASE empdb SET SEARCH_PATH TO scott;
