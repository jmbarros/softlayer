#!/bin/bash

####created by jmbarros at tech4it.com.br                                                                    ##### 
####free to distributing, just give me some credits, okay ? :)                                               #####
#### based http://docs.cloudstack.apache.org/projects/cloudstack-installation/en/4.5/qig.html#configuration  ####
#################################################################################################################

echo "[cloudstack]
name=cloudstack
baseurl=http://cloudstack.apt-get.eu/rhel/4.5/
enabled=1
gpgcheck=0" >> /etc/yum.repos.d/cloud_s.repo
yum repolist

yum -y install nfs-utils ntp mysql-server cloudstack-management



mv /etc/sysconfig/nfs /etc/sysconfig/old_nfs
echo "LOCKD_TCPPORT=32803
LOCKD_UDPPORT=32769
MOUNTD_PORT=892
RQUOTAD_PORT=875
STATD_PORT=662
STATD_OUTGOING_PORT=2020" > /etc/sysconfig/nfs

echo "/secondary *(rw,async,no_root_squash,no_subtree_check)
/primary *(rw,async,no_root_squash,no_subtree_check)" > /etc/exports

mkdir /primary
mkdir /secondary



mv /etc/my.cnf /etc/old_my.cnf
echo "[mysqld]
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format = 'ROW'
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid" > /etc/my.cnf


cloudstack-setup-databases cloud:password@localhost --deploy-as=root

service ntpd start
service rpcbind start
service nfs start
service mysqld start

chkconfig ntpd on
chkconfig rpcbind on
chkconfig nfs on
chkconfig mysqld on
