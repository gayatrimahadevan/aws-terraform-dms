# aws-terraform-dms
Terraform Code to build DMS tasks Oracle and MS SQL server to Postgres RDS
/* Prepare Environment */
1. Spin a EC2 ubuntu 20 with 40GB and ports 22,1433,1521,5500 open.
/* Steps to Install Docker */
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
2. Install postgres RDS and create appuser and eb_schema to hold migrated data.
Create RDS
Create demodb database and appuser with eb_schema

/* Steps to run Oracle on Docker */
/* Steps to create Oracle Docker Image*/
/* Clone the Oracle docker-images git repository */
git clone https://github.com/oracle/docker-images.git

/* Download Install binaries from Oracle website. https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html */
/*Copy them to the docker machine.*/
pscp -i .\acg.ppk '.\LINUX.X64_193000_db_home.zip' ubuntu@100.26.190.208:/tmp
mv /tmp/LINUX.X64_193000_db_home.zip .

/*Build the image*/
./buildContainerImage.sh -e -v 19.3.0

/*Create directory to contain data to persist*/
mkdir oracle_data
chmod a+w oracle_data

/*Run Image*/
docker run --name myorcl \
-p 1521:1521 -p 5500:5500 \
-e ORACLE_PWD=Deloitte.0 \
-e ORACLE_EDITION=enterprise \
-e ENABLE_ARCHIVELOG=true \
-v /home/ubuntu/oracle_data:/opt/oracle/oradata \
oracle/database:19.3.0-ee
docker exec myorcl /u01/app/oracle/setPassword.sh Deloitte.0
/* Create SCOTT schema using scott.sql */
/* Create dms_user will DMS permissions on PDB using dms_user.sql */

docker exec -it myorcl sqlplus pdbadmin@ORCLPDB1

/* Steps to run MS SQL Server on Docker */
/* Pull image and run */
docker pull mcr.microsoft.com/mssql/server
/*Create directory to contain data to persist*/
mkdir mssql_data
chmod a+w mssql_data
/*Copy Sample database from microsoft to data directory mssql_data  to restore.*/

mv /tmp/AdventureWorksLT2019.bak .

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Deloitte.0" -p 1433:1433 -d  -v /home/ubuntu/mssql_data:/var/opt/mssql --name mymssql mcr.microsoft.com/mssql/server
/* URL for to downloand sample backup file - https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms */
/* Create dmsuser with deloitte.0 as password and AdventureWorksLT2019 as database owener */
