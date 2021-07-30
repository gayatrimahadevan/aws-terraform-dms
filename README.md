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

Follow AWS documentation to [enable SSL](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.Oracle.html#CHAP_Security.SSL.Oracle)
```
docker exec -it myorcl /bin/bash

cd /opt/oracle/oradata/
mkdir server_wallet
openssl genrsa -out self-rootCA.key 2048
openssl req -x509 -new -nodes -key self-rootCA.key -sha256 -days 365 -out self-rootCA.pem
orapki wallet create -wallet /opt/oracle/oradata/server_wallet -pwd  Wallet@123 -auto_login_local
orapki wallet add -wallet /opt/oracle/oradata/server_wallet -trusted_cert -cert self-rootCA.pem -pwd Wallet@123
orapki wallet display -wallet /opt/oracle/oradata/server_wallet -pwd Wallet@123
orapki wallet add -wallet /opt/oracle/oradata/server_wallet -dn "CN=dms" -keysize 2048 -sign_alg sha256 -pwd Wallet@123
openssl pkcs12 -in /opt/oracle/oradata/server_wallet/ewallet.p12 -nodes -out nonoracle_wallet.pem
openssl req -new -key nonoracle_wallet.pem -out self-signed-oracle.csr
openssl req -noout -text -in self-signed-oracle.csr | grep -i signature
openssl x509 -req -in self-signed-oracle.csr -CA self-rootCA.pem -CAkey self-rootCA.key -CAcreateserial -out self-signed-oracle.crt -days 365 -sha256
orapki wallet add -wallet /opt/oracle/oradata/server_wallet -user_cert -cert self-signed-oracle.crt -pwd Wallet@123
lsnrctl start
sqlplus -L pdbadmin/Deloitte.0@ORCLPDB_ssl
SELECT SYS_CONTEXT('USERENV', 'network_protocol') FROM DUAL;

orapki wallet create -wallet C:\Users\gkolluru\app\wallet -pwd  Wallet@123 -auto_login
orapki wallet add -wallet C:\Users\gkolluru\app\wallet  -trusted_cert -cert self-signed-oracle.crt -pwd Wallet@123
orapki wallet display -wallet C:\Users\gkolluru\app\wallet -pwd Wallet@123
OU=workplace,O=Default Company Ltd,L=Default City,C=us
orapki wallet export -wallet C:\Users\gkolluru\app\wallet -pwd Wallet@123 -dn "OU=workplace,O=Default Company Ltd,L=Default City,C=us" -cert ./oracle-db-certificate.pem
```

Steps to run MS SQL Server on Docker

Pull image and run 

`docker pull mcr.microsoft.com/mssql/server`

Create directory to contain data to persist

`mkdir mssql_data`

`cd mssql_data`

`mkdir ReplData`

`cd ..`

`chmod a+w mssql_data`

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
USE master 
EXEC sp_replicationdboption 
@dbname = 'AdventureWorksLT2019', 
@optname = 'publish', 
@value = 'true'
GO
select name from sys.databases where is_distributor=1
```

2. Install postgres RDS and create appuser and eb_schema to hold migrated data.
Create RDS
Create demodb database and appuser with eb_schema
