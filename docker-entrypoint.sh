#!/bin/bash
set -e
# made by sneaky of Rothaar Systems (Andre Scholz)

# V2017-03-06-17-45
echo "<VirtualHost *:80>" > /etc/apache2/000-default.conf
echo "ServerAdmin webmaster@localhost" >> /etc/apache2/000-default.conf
echo "DocumentRoot /var/www/html" >> /etc/apache2/000-default.conf
echo "</VirtualHost>" >> /etc/apache2/000-default.conf
echo "Action: "
echo "$ACTION"
case "$ACTION" in
	installcert)
        if [ -z $HOST_NAME ]; then
                echo "Host is missing"
                exit 1
        fi # second parameter is missing

        # Apache gets grumpy about PID files pre-existing
        rm -f /var/run/apache2/apache2.pid
        #service apache2 start
        mkdir --parents /var/keys/$HOST_NAME
        cd /root
        curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh >acme.sh
        chmod +x ./acme.sh
        ./acme.sh --issue --standalone --log --debug 2 -d $HOST_NAME
        a2dissite 000-default.conf
        a2ensite apache-without-ssl 
        ./acme.sh --installcert -d $HOST_NAME \
        --certpath /var/keys/$HOST_NAME/site.cer \
        --keypath  /var/keys/$HOST_NAME/site.key  \
        --capath   /var/keys/$HOST_NAME/ca.cer  \
        --fullchainpath /var/keys/$HOST_NAME/fullchain.cer 
        #--reloadcmd  "service apache2 reload"
        a2ensite apache-with-ssl
        #service apache2 stop
	;;      
	
	renew)
        if [ -z $HOST_NAME ]; then
                echo "Host is missing" 
                exit 1
        fi # second parameter is missing
       
        # Apache gets grumpy about PID files pre-existing
        rm -f /var/run/apache2/apache2.pid
        # service apache2 start
        mkdir --parents /var/keys/$HOST_NAME
        cd /root
        curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh >acme.sh
        chmod +x ./acme.sh
        ./acme.sh --renew --log -d  $HOST_NAME --force --standalone
        a2dissite 000-default.conf  
        a2ensite apache-without-ssl    
        
        a2ensite apache-with-ssl
        service apache2 stop
	;;
	
	*)
        a2dissite 000-default.conf  
        a2ensite apache-without-ssl    
	    a2ensite apache-with-ssl
	;;
esac

rm -f /var/run/apache2/apache2.pid
exec apache2 -DFOREGROUND
exit 0
