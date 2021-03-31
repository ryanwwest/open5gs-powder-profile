# install open5gs
apt -y update
apt -y install software-properties-common
add-apt-repository ppa:open5gs/latest
apt -y update
apt -y install open5gs # might have to press enter here

# install open5gs web UI
sudo apt -y install curl nodejs
curl -sL https://deb.nodesource.com/setup_12.x | bash -
curl -sL https://open5gs.org/open5gs/assets/webui/install | bash -
#curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
#curl -sL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -

