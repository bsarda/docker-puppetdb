# written by Benoit Sarda
# creates a puppetdb on centos 7 - should be linked to postgres and to puppetdb
#   bsarda <b.sarda@free.fr>
#
FROM centos:centos7.2.1511
MAINTAINER Benoit Sarda <b.sarda@free.fr>

# expose port for agent comm and replication
EXPOSE 8081 8082
# env variables
# including AUTOSIGN parameters (csv values)
ENV DB_SERVER=db DB_PORT=5432 DB_NAME=puppetdb  DB_USER=puppetdb DB_PASSWORD=puppetdb PUPPET_MASTER=puppet.local

# install packages
RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-$(uname -r | sed 's/.*el\([0-9]\).*/\1/g').noarch.rpm && \
	groupadd puppetdb && useradd puppetdb -g puppetdb && \
	yum install -y net-tools iproute openssl && \
	yum install -y puppetdb puppetdb-termini

# put scripts files and change database.ini content
COPY ["init.sh", "/etc/puppetlabs/puppetdb/init.sh"]

# change ownership and permissions
RUN mkdir -p /etc/puppetlabs/puppet/ssl && mkdir -p /etc/puppetlabs/puppetdb/ssl/ && \
	chown -Rf puppetdb:puppetdb /var/log/puppetlabs/ && \
	chmod -Rf 0750 /var/log/puppetlabs/ && \
	chmod a+x /etc/puppetlabs/puppetdb/init.sh

# start
CMD ["/etc/puppetlabs/puppetdb/init.sh"]

