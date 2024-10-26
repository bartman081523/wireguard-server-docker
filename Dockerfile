FROM linuxserver/wireguard

RUN apt-get update && apt-get install -y iproute2 qrencode

# Generate keys
RUN wg genkey | tee /config/wg-privatekey | wg pubkey | tee /config/wg-publickey
RUN wg genkey | tee /config/client-privatekey | wg pubkey | tee /config/client-publickey

# Get server IP address dynamically and generate server config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
