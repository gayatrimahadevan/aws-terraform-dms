# aws-terraform-dms
Terraform Code to build DMS tasks Oracle and MS SQL server to Postgres RDS

## Prepare Environment

### Set VPC,EC2 & Run oracle & MSSQL server on docker

1.Spin a EC2 ubuntu 20 with 40GB and ports __22,1433,1521,5500__ open.

#### Install Docker

`sudo apt update`

`sudo apt install apt-transport-https ca-certificates curl software-properties-common`

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"`

`apt-cache policy docker-ce`

`sudo apt install docker-ce`

`sudo usermod -aG docker ${USER}`

### Run Oracle on Docker

 Steps to create Oracle Docker Image
 
Clone the Oracle docker-images git repository

`git clone https://github.com/oracle/docker-images.git`

Download Install binaries from [Oracle website.](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html)

Copy them to the docker machine.

`pscp -i .\acg.ppk '.\LINUX.X64_193000_db_home.zip' ubuntu@100.26.190.208:/tmp`

`mv /tmp/LINUX.X64_193000_db_home.zip .`

Build the image

`./buildContainerImage.sh -e -v 19.3.0`

Create directory to contain data to persist

`mkdir oracle_data`

`chmod a+w oracle_data`

Run Image

```
docker run --name myorcl \
-p 1521:1521 \
-p 5500:5500 -d \
-e ORACLE_PWD=XXX \
-e ORACLE_EDITION=enterprise \
-e ENABLE_ARCHIVELOG=true \
-v /home/ubuntu/oracle_data:/opt/oracle/oradata \
oracle/database:19.3.0-ee
```

Create SCOTT schema using scott.sql 
Create dms_user will DMS permissions on PDB using dms_user.sql

`docker exec -it myorcl sqlplus pdbadmin@ORCLPDB1`
Steps enable SSL

Steps to run MS SQL Server on Docker

Pull image and run 

`docker pull mcr.microsoft.com/mssql/server`

Create directory to contain data to persist

`mkdir mssql_data`

`chmod a+w mssql_data`

`cd mssql_data`

`mkdir RplData`

`chmod a+rw RplData`

Copy Sample database from microsoft to data directory mssql_data  to restore.

Downloand sample backup file. [URL](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)

Create dms_user with xxxx as password and AdventureWorksLT2019 as database owener

`mv /tmp/AdventureWorksLT2019.bak .`

```
docker run -e "ACCEPT_EULA=Y" \
-e "SA_PASSWORD=XXX" \
-p 1433:1433 -d \
-v /home/ubuntu/mssql_data:/var/opt/mssql \
--name mymssql mcr.microsoft.com/mssql/server:latest
```
Follow the AWS documentation to enable replication in MSSQL server [here](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.SQLServer.html#CHAP_Source.SQLServer.Prerequisites)

Login as **sa** user and Enable distribution, Create distribution database & publish
```
USE master 
EXEC sp_replicationdboption 
@dbname = 'AdventureWorksLT2019', 
@optname = 'publish', 
@value = 'true'
GO
select name from sys.databases where is_distributor=1

select @@SERVERNAME
use master
exec sp_adddistributor 
 @distributor = 'XXX',
 @heartbeat_interval=10,
 @password='XXXXX'
USE master
EXEC sp_adddistributiondb 
    @database = 'dist1', 
    @security_mode = 1;
GO
exec sp_adddistpublisher 
@publisher = 'XXX', 
@distribution_db = 'dist1';
GO
```

2. Install postgres RDS and create appuser and eb_schema to hold migrated data.
Create RDS
Create demodb database and appuser with eb_schema
