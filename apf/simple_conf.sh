#!/bin/bash

####created by jmbarros at tech4it.com.br                              ##### 
####free to distributing, just give me some credits, okay ? :)         #####
###########################################################################

PORTS="22"

#create directory
mkdir $HOME/download_temp

#get AFP and install AFP
wget -P $HOME/download_temp/ http://www.rfxnetworks.com/downloads/apf-current.tar.gz
chmod +x $HOME/download_temp/apf-current.tar.gz
tar -xvf $HOME/download_temp/apf-current.tar.gz -C $HOME/download_temp/
cd $HOME/download_temp/apf-*
/bin/bash install.sh

#change the rules
sed -i -e "s/DEVEL_MODE=.*/DEVEL_MODE=\"0\"/" /etc/apf/conf.apf
sed -i -e "s/IFACE_IN=.*/IFACE_IN=\"eth1\"/" /etc/apf/conf.apf
sed -i -e "s/IFACE_OUT=.*/IFACE_OUT=\"eth1\"/" /etc/apf/conf.apf
sed -i -e "s/IFACE_TRUSTED=.*/IFACE_TRUSTED=\"eth0\"/" /etc/apf/conf.apf
sed -i -e "s/IG_TCP_CPORTS=.*/IG_TCP_CPORTS=\"$PORTS\"/" /etc/apf/conf.apf

#start
/usr/local/sbin/apf -r
chkconfig apf on