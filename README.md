# vagrant
Testing vagrant
## How to start
* Install vagrant according to your system from https://www.vagrantup.com/downloads.html
* Add vagrant to your PATH
* Install vbox plugin (optional)
  * vagrant plugin install vagrant-vbguest
  * vagrant plugin list
## How to load a Vagrantfile
* Go to the directory containing the Vagrantfile with the command line
* Run the following command and wait for its completion:
   * vagrant up
* Connect to VM
   * vagrant ssh
* Open VirtualBox, the VM should be there! (optional)
* Default user/password:
   * vagrant/vagrant
* Halt VM:
   * vagrant halt
## Start minikube
* minikube start --vm-driver=none
