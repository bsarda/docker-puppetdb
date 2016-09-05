#!/bin/bash

if [ ! -f /etc/puppetlabs/initialized ]; then
	echo "This is the first launch - will init ssl certs, db parameters..."
	# change database connection settings
	sed -i.bkp "s@subname.*@subname = //$DB_SERVER:$DB_PORT/$DB_NAME@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini
	sed -i "s@username.*@username = $DB_USER@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini
	sed -i "s@password.*@password = $DB_PASSWORD@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini
	# generate certs
	/opt/puppetlabs/puppet/bin/puppet cert --generate $(hostname)
        cp /etc/puppetlabs/puppet/ssl/certs/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).cert.pem
        cp /etc/puppetlabs/puppet/ssl/public_keys/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).public_key.pem
        cp /etc/puppetlabs/puppet/ssl/private_keys/$(hostname).pem /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pem
        openssl pkcs8 -topk8 -inform PEM -outform DER -in /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pem -out /etc/puppetlabs/puppetdb/ssl/$(hostname).private_key.pk8 -nocrypt
        chown -Rf puppetdb:puppetdb /etc/puppetlabs/
	# launch init
	/opt/puppetlabs/bin/puppetdb ssl-setup -f
	# create flag file
	touch /etc/puppetlabs/initialized;
else
	echo "PuppetDB already initialized, no need to reinit - just start."
fi


# then start it.
/opt/puppetlabs/bin/puppetdb foreground

