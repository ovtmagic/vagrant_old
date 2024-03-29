# apps
#echo "set -g mouse" > /home/vagrant/.tmux.conf

# Docker
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    make \
    python \
    software-properties-common
apt-get install -y aptitude git socat
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
#sudo apt-get install -y kubectl=1.14.2-00
sudo apt-get install -y kubectl


# Minikube
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 > /dev/null 2>&1
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.1.0/minikube-linux-amd64 > /dev/null 2>&1
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.4.0/minikube-linux-amd64 > /dev/null 2>&1
chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube


# Helm
#curl -s https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz|tar zx
curl -s https://storage.googleapis.com/kubernetes-helm/helm-v2.16.1-linux-amd64.tar.gz|tar zx
cp linux-amd64/helm /usr/local/bin
cp linux-amd64/tiller /usr/local/bin

# Docker compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# k9s
curl -SL  https://github.com/derailed/k9s/releases/download/v0.17.1/k9s_Linux_x86_64.tar.gz |tar zxv -C /tmp
sudo cp /tmp/k9s /usr/local/bin

# Clone repo from kubernets course
#runuser -l vagrant -c "mkdir -p /home/vagrant/curso;cd /home/vagrant/curso;git clone https://github.com/LevelUpEducation/kubernetes-demo.git"

# Install and start minikube --------------------------------------------------------------
INSTALL_MINIKUBE="true"
if [[ "$INSTALL_MINIKUBE" == "true" ]]; then
  sudo -i minikube start --vm-driver=none --kubernetes-version=v1.17.3
  sudo -i /vagrant/scripts/copy_k8s_conf.sh
  helm init
  sudo minikube addons enable metrics-server
fi

# User configuration
runuser -l vagrant -c "echo 'source <(kubectl completion bash)' >> /home/vagrant/.bashrc"
