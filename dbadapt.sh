#!/bin/bash
# ENV DB_SERVER=db DB_PORT=5432 DB_USER=puppetdb DB_PASSWORD=puppetdb PUPPET_MASTER=puppet.local
sed -i.bkp "s@subname.*@subname = //$DB_SERVER:$DB_PORT/$DB_NAME@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini
sed -i "s@username.*@username = $DB_USER@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini
sed -i "s@password.*@password = $DB_PASSWORD@gi" /etc/puppetlabs/puppetdb/conf.d/database.ini


