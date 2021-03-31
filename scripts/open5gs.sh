# this script should be run as root
# print every command
set -x


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

cp /local/repository/config/mme.yaml /ect/open5gs/mme.yaml
cp /local/repository/config/sgwu.yaml /ect/open5gs/sgwu.yaml

systemctl restart open5gs-mmed
systemctl restart open5gs-sgwud

echo "Setup 5G Core"

cp /local/repository/config/amf.yaml /ect/open5gs/amf.yaml
cp /local/repository/config/upf.yaml /ect/open5gs/upf.yaml

systemctl restart open5gs-amfd
systemctl restart open5gs-upfd


