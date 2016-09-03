#!/bin/bash
set -e
# made by sneaky of Rothaar Systems (Andre Scholz)
# V2016-09-03-15-45
touch /etc/apache2/sites-available/000-default.conf

if [ -z $1 ]; then

	# Apache gets grumpy about PID files pre-existing
	rm -f /var/run/apache2/apache2.pid
	service apache2 start
	mkdir --parents /var/keys/$1
	cd /root
	curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh >acme.sh
	chmod +x ./acme.sh
	./acme.sh --issue -d $1 -w /var/www/html/
	a2dissite 000-default.conf
	a2ensite apache-without-ssl 
	./acme.sh --installcert -d $1 \
	--certpath /var/keys/$1/site.cer \
	--keypath  /var/keys/$1/site.key  \
	--capath   /var/keys/$1/ca.cer  \
	--fullchainpath /var/keys/$1/fullchain.cer 
	#--reloadcmd  "service apache2 reload"
	a2ensite apache-with-ssl
	service apache2 stop
fi # if there should be something (new) registered	

rm -f /var/run/apache2/apache2.pid
exec apache2 -DFOREGROUND
exit 0
