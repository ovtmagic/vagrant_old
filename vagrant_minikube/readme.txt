# To install virtualbox guest
vagrant plugin install vagrant-vbguest
vagrant plugin list

# To open kubernetes dashboard
minikube dashboard --url
kubectl proxy --address=192.168.0.128 --disable-filter
http://192.168.0.128:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/

# To resize disk
vagrant plugin install vagrant-disksize
in Vagrantfile: config.disksize.size = '60GB'
