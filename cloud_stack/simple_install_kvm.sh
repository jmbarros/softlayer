#!/bin/bash

####created by jmbarros at tech4it.com.br                              ##### 
####free to distributing, just give me some credits, okay ? :)         #####
###########################################################################

echo "[cloudstack]
name=cloudstack
baseurl=http://cloudstack.apt-get.eu/rhel/4.5/
enabled=1
gpgcheck=0" >> /etc/yum.repos.d/cloud_s.repo
yum repolist

echo "vnc_listen=0.0.0.0" >> /etc/libvirt/qemu.conf

echo "listen_tls = 0
listen_tcp = 1
tcp_port = \"16059\"
auth_tcp = \"none\"
mdns_adv = 0" >> /etc/libvirt/libvirtd.conf

echo "LIBVIRTD_ARGS=\"--listen"\" >> /etc/sysconfig/libvirtd

yum -y install cloudstack-agent
