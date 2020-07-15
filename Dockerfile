FROM oraclelinux:7
LABEL maintainer="xuanloc0511@gmail.com"

RUN curl -o oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm
RUN yum -y localinstall oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm

# Download oracle-database-xe-18c-1.0-1.x86_64.rpm from
# https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
RUN echo 'Download oracle-database-xe-18c-1.0-1.x86_64.rpm from https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html'
#RUN curl -o oracle-database-xe-18c-1.0-1.x86_64.rpm https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm
RUN curl -o oracle-database-xe-18c-1.0-1.x86_64.rpm - L https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm
#COPY oracle-database-xe-18c-1.0-1.x86_64.rpm .
ENV ORACLE_DOCKER_INSTALL=true
RUN yum -y localinstall oracle-database-xe-18c-1.0-1.x86_64.rpm

RUN rm oracle-database-xe-18c-1.0-1.x86_64.rpm \
	&&  rm oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm

ARG PASSWORD=oracle
ENV ORACLE_PASSWORD=$PASSWORD \
	ORACLE_CONFIRM_PASSWORD=$PASSWORD \
	ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
	ORACLE_SID=XE

# RUN echo $ORACLE_PASSWORD $ORACLE_CONFIRM_PASSWORD
RUN export PATH=$ORACLE_HOME/bin:$PATH
RUN /etc/init.d/oracle-xe-18c configure
COPY listener.ora /opt/oracle/product/18c/dbhomeXE/network/admin/listener.ora
COPY tnsnames.ora /opt/oracle/product/18c/dbhomeXE/network/admin/tnsnames.ora
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 1521/tcp 5500/tcp
ENTRYPOINT ["/bin/sh", "-c", "/entrypoint.sh"]
