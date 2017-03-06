# 1. General info

This Dockerfile builds an apache gateway - it's still beta!

	docker run -d --name apache-gateway \
	-e HOST_NAME=www.rothaarsystems.de \
	-v /home/apache-gateway/keys:/var/keys \
	-v /home/apache-gateway/sites-available:/etc/apache2/sites-available \
	-v /home/apache-gateway/acme:/root/.acme.sh \
	sneaky/apache-gateway

[![](https://images.microbadger.com/badges/image/sneaky/apache-gateway.svg)](https://microbadger.com/images/sneaky/apache-gateway "Get your own image badge on microbadger.com") [Get your own image badge on microbadger.com!](https://microbadger.com)