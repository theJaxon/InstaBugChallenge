# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.
  
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "InstaBug"
    config.vm.box_check_update = false
    config.vm.synced_folder ".", "/vagrant", type: "rsync"

    config.vm.network "forwarded_port", guest: 22, host: 22 # ssh
    config.vm.network "forwarded_port", guest: 3000, host: 3000 # Gitea
    config.vm.network "forwarded_port", guest: 4222, host: 4222 # cyprus
    config.vm.network "forwarded_port", guest: 8080, host: 8080 # Jenkins
  

     config.vm.provider "virtualbox" do |vb|

       vb.memory = "8192"
       vb.cpus = 2
     end

     config.vm.provision "shell", inline: <<-SHELL
     # Docker
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common git
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo "Docker was Successfully installed"

    # Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose was Successfully installed"
    
    # git config
    git config --global user.name "jaxon"
    git config --global user.email jaxon@jaxon.com

    #gitea
    wget -O gitea https://dl.gitea.io/gitea/1.11.5/gitea-1.11.5-linux-amd64 && chmod +x gitea
    sudo adduser \
    --system \
    --shell /bin/bash \
    --gecos 'Git Version Control' \
    --group \
    --disabled-password \
    --home /home/git \
    git
    sudo mkdir -p /var/lib/gitea/{custom,data,log}
    sudo chown -R git:git /var/lib/gitea/
    sudo chmod -R 750 /var/lib/gitea/
    sudo mkdir /etc/gitea
    sudo chown root:git /etc/gitea
    sudo chmod 770 /etc/gitea
    export GITEA_WORK_DIR=/var/lib/gitea/
    sudo cp gitea /usr/local/bin/gitea

    # add gitea service to systemd
    cd /etc/systemd/system/ && sudo wget https://raw.githubusercontent.com/go-gitea/gitea/master/contrib/systemd/gitea.service && cd $HOME
    sudo systemctl enable gitea
    sudo systemctl start gitea

    # Jenkins
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo usermod -aG docker jenkins
    sudo apt-get install -y openjdk-8-jre jenkins 
    echo "Jenkins was Successfully installed\n\n"
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword

     SHELL
  end
  