# written by Benoit Sarda
# creates the puppetdb. needs to be linked to a postgresql server and a puppetserver 
#
#   bsarda <b.sarda@free.fr>
#
FROM centos:centos7.2.1511
MAINTAINER Benoit Sarda <b.sarda@free.fr>

# expose server port for agent comm
### EXPOSE 8140
# env variables
# including AUTOSIGN parameters (csv values)
### ENV hostname=puppet.local MEMORY_MB_TO_HAVE=2048 AUTOSIGN=*.local,puppettest*

# install packages
### RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-$(uname -r | sed 's/.*el\([0-9]\).*/\1/g').noarch.rpm && \
###	yum clean all && \
###	yum install -y net-tools puppetserver iproute && \
###	rm -rf /etc/puppetlabs/puppet/ssl/* && \
###	sed -i.bkp 's@export PATH@PATH=$PATH:/opt/puppetlabs/bin/\nexport PATH@g' /root/.bash_profile && \
###	sed -i.bkp 's@export PATH@PATH=$PATH:/opt/puppetlabs/bin/\nexport PATH@g' /etc/profile && \
###	ip=$(ip a | awk '/^[[:space:]]*inet[[:space:]]/ && !/127/' | sed 's/[[:space:]]*inet[[:space:]]\(.*\)\/.*/\1/g') && \
###	echo "$ip  puppet.local puppet" >> /etc/hosts && \
###	useradd puppet -g puppet

# put scripts files for calling later
### RUN mkdir -p /opt/config
### COPY ["autosign.sh", "memtest.sh","/opt/config/"]
### COPY ["run.sh", "/opt/"]
### COPY ["puppet.conf","/etc/puppetlabs/puppet/puppet.conf"]
### RUN chmod a+x /opt/config/* && chmod a+x /opt/run.sh 

# change ownership and permissions
### RUN mkdir /etc/puppetlabs/puppet/ssl && \
###	chown -Rf puppet:puppet /var/log/puppetlabs/ && \
###	chown -Rf puppet:puppet /etc/puppetlabs && \
###	chmod -Rf 0750 /var/log/puppetlabs/

# start
### CMD ["/opt/run.sh"]
