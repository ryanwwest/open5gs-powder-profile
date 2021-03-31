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

