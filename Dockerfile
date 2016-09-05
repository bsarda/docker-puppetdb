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
### COPY ["database.ini", "dbadapt.sh", "/etc/puppetlabs/puppetdb/conf.d/"]
### RUN chmod a+x /etc/puppetlabs/puppetdb/conf.d/dbadapt.sh && /etc/puppetlabs/puppetdb/conf.d/dbadapt.sh
COPY ["init.sh", "/etc/puppetlabs/puppetdb/init.sh"]

# change ownership and permissions
RUN mkdir -p /etc/puppetlabs/puppet/ssl && mkdir -p /etc/puppetlabs/puppetdb/ssl/ && \
	chown -Rf puppetdb:puppetdb /var/log/puppetlabs/ && \
	chmod -Rf 0750 /var/log/puppetlabs/

# generate certificates, copy them and chown
### RUN /opt/puppetlabs/puppet/bin/puppet cert --generate $(hostname) && \
###	cp /etc/puppetlabs/puppet/ssl/certs/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).cert.pem && \
###	cp /etc/puppetlabs/puppet/ssl/public_keys/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).public_key.pem && \
###	cp /etc/puppetlabs/puppet/ssl/private_keys/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pem && \
###	openssl pkcs8 -topk8 -inform PEM -outform DER -in /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pem -out /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pk8 -nocrypt && \
###	chown -Rf puppetdb:puppetdb /etc/puppetlabs/

# launch init
### RUN /opt/puppetlabs/bin/puppetdb ssl-setup -f

# start
### CMD ["/opt/puppetlabs/bin/puppetdb","foreground"]
CMD ["/etc/puppetlabs/puppetdb/init.sh"]

