#!/bin/bash

# copy minikube conf
cp -r /root/.kube /home/vagrant
cp -r /root/.minikube /home/vagrant

# fix user
sudo sed -i "s/root/home\/vagrant/g" /home/vagrant/.kube/config
sudo sed -i "s/root/home\/vagrant/g" /home/vagrant/.minikube/machines/minikube/config.json

chown -R vagrant:vagrant /home/vagrant/.kube
chown -R vagrant:vagrant /home/vagrant/.minikube
