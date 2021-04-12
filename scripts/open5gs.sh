# this script should be run as root
# print every command
set -x

### Enable IPv4/IPv6 Forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

### Add NAT Rule
# Probably need to change these values?
sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
sudo ip6tables -t nat -A POSTROUTING -s 2001:230:cafe::/48 ! -o ogstun -j MASQUERADE


# install open5gs
apt -y update
apt -y install software-properties-common
add-apt-repository ppa:open5gs/latest
apt -y update
apt -y install npm open5gs # might have to press enter here

echo Now install Open5GS Web UI

# install open5gs web UI
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt -y install nodejs
curl -sL https://open5gs.org/open5gs/assets/webui/install | bash -
#curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
#curl -sL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -


echo "Setup 4G/ 5G NSA Core"

cp /local/repository/config/mme.yaml /etc/open5gs/mme.yaml
cp /local/repository/config/sgwu.yaml /etc/open5gs/sgwu.yaml

systemctl restart open5gs-mmed
systemctl restart open5gs-sgwud

echo "Setup 5G Core"

cp /local/repository/config/amf.yaml /etc/open5gs/amf.yaml
cp /local/repository/config/upf.yaml /etc/open5gs/upf.yaml

echo "\nnet.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

systemctl restart open5gs-amfd
systemctl restart open5gs-upfd

