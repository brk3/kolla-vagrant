#!/bin/bash

sudo groupadd -f docker
sudo usermod -a -G docker vagrant

sudo yum install -y https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm
sudo service docker restart

sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm

sudo yum install -y \
  gcc \
  git \
  git-review \
  libffi-devel \
  libxml2-devel \
  libxslt-devel \
  MySQL-python \
  openssl \
  openssl-devel \
  python-devel \
  python-pip \
  vim

sudo pip install \
  ansible \
  docker-py \
  git-review \
  shade

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
echo '. ~/.git-completion.bash' >> ~/.bashrc

if [[ ! -d "compose" ]]; then
  git clone http://github.com/docker/compose
  cd compose
  sudo pip install -r requirements.txt
  sudo pip install -e .
  cd ..
fi

if [[ ! -d "kolla" ]]; then
  git clone https://github.com/stackforge/kolla.git
fi

sudo chown -R vagrant:vagrant /home/vagrant

sudo setenforce permissive
