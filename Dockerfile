FROM ubuntu:latest

RUN apt-get update && apt-get install -y wireguard iproute2 qrencode

# Create the config directory
RUN mkdir /config

# Generate keys (consider more secure key generation in production)
RUN wg genkey | tee /config/wg-privatekey | wg pubkey | tee /config/wg-publickey
RUN wg genkey | tee /config/client-privatekey | wg pubkey | tee /config/client-publickey


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
