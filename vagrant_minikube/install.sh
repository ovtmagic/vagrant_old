# apps
echo "set -g mouse" > /home/vagrant/.tmux.conf
apt-get install -y aptitude git socat

# Docker
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -y update
# apt-cache madison docker-ce -> to see versions
sudo apt-get install -y docker-ce=18.03.1~ce-0~ubuntu
sudo usermod -aG docker vagrant


# Kubernetes
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


# Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 > /dev/null 2>&1
chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube


# Helm
curl -s |https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz|tar zx
cp linux-amd64/helm /usr/local/bin
cp linux-amd64/tiller /usr/local/bin

# Docker compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone repo from kubernets course
runuser -l vagrant -c "mkdir -p /home/vagrant/curso;cd /home/vagrant/curso;git clone https://github.com/LevelUpEducation/kubernetes-demo.git"
