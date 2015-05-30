#!/bin/sh

hostname=("192.168.228.30 bootstrap")

echo "" > /home/vagrant/.ssh/config

echo "127.0.0.1   chef localhost localhost.localdomain localhost4 localhost4.localdomain4"  > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6"      >> /etc/hosts

for item in "${hostname[@]}"
do

  tmp=(${item})

  cp /vagrant/.vagrant/machines/bootstrap/virtualbox/private_key /home/vagrant/.ssh/${tmp[1]}_private_key

  echo "Host ${item}"                                >> /home/vagrant/.ssh/config
  echo "  Port 22"                                   >> /home/vagrant/.ssh/config
  echo "  IdentityFile ~/.ssh/${tmp[1]}_private_key" >> /home/vagrant/.ssh/config
  echo "  IdentitiesOnly yes"                        >> /home/vagrant/.ssh/config
  echo "  UserKnownHostsFile /dev/null"              >> /home/vagrant/.ssh/config
  echo "  StrictHostKeyChecking no"                  >> /home/vagrant/.ssh/config
  echo "  PasswordAuthentication no"                 >> /home/vagrant/.ssh/config

  echo "" >> /home/vagrant/.ssh/config

  echo ${item} >> /etc/hosts

done

chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/*
