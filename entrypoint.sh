#!/bin/bash

SERVER_PRIVATE_KEY=$(cat /config/wg-privatekey)
SERVER_PUBLIC_KEY=$(cat /config/wg-publickey)
CLIENT_PRIVATE_KEY=$(cat /config/client-privatekey)
CLIENT_PUBLIC_KEY=$(cat /config/client-publickey)
SERVER_IP=$(ip route get 1 | awk '{print $NF;exit}')

cat << EOF > /config/wg0.conf
[Interface]
Address = 10.200.200.1/24
ListenPort = 51820
PrivateKey = ${SERVER_PRIVATE_KEY}

[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = 10.200.200.2/32
EOF

cat << EOF > /config/wg0-client.conf
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = 10.200.200.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
Endpoint = ${SERVER_IP}:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

# Generate QR code
qrencode -t png -o /config/wg0.png <(wg showconf wg0)

# Start WireGuard
exec wg-quick up wg0
