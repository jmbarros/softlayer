#!/bin/bash
###script to mount automatically object storage at your instance
###created by jmbarros at tech4it.com.br
###free to distributing, just give me some credits, okay ? :)
###########################################################################
#this script can be used to mount an Object Storage in your Linux instance
#You can mount temporaly or automaticaly (even when servers reboot), just 
#have to change the flag FSTAB to yes for automaticaly and NO for temporaly
echo "Digite seu usuário"
read USERNAME

echo "Digite sua APIKEY"
read APIKEY

#echo "Digite a URL de autenticacao"
#read URL_AUTH

echo "Digite o diretório que pretende montar seu objectstorage (exemplo: /object) "
read MOUNT_POINT

FSTAB=YES

#set your SoftLayer username
#USERNAME=""

#set your Softlayer APIKEY
#APIKEY=""

#set your SoftLayer url Auth
URL_AUTH="https://dal05.objectstorage.softlayer.net/auth/v1.0/"
#please remember declare the full path (ex. /var/www/htm/)
#MOUNT_POINT="/object"



############## FROM WHERE IS NOT NECESSARY YOUR INTERACTION #############
####### just change the script if you realy know what you're doing ######
#########################################################################
#create directory temp
mkdir $HOME/download_temp
#create mount point
mkdir $MOUNT_POINT

#install applications
yum -y install gcc make fuse fuse-devel curl-devel libxml2-devel openssl-devel
wget -P $HOME/download_temp/ https://github.com/redbo/cloudfuse/archive/master.zip
chmod +x $HOME/download_temp/master.zip
unzip $HOME/download_temp/master.zip -d $HOME/download_temp
cd $HOME/download_temp/cloudfuse-master
./configure
make
make install
rm -rf $HOME/download_temp

case $FSTAB in
YES)
                echo "Creating in /etc/fstab and mounting in $MOUNT_POINT..."
                echo "cloudfuse $MOUNT_POINT fuse username=$USERNAME,api_key=$APIKEY,authurl=$URL_AUTH,allow_root,default_permissions,kernel_cache,big_writes,intr 0 0" >> /etc/fstab
                /bin/mount -a                 
        ;;
NO)
                echo "Mounting in $MOUNT_POINT..."
                /usr/local/bin/cloudfuse -o username=$USERNAME api_key=$APIKEY authurl=$URL_AUTH $MOUNT_POINT
        ;;
*)
                echo "Do you HAVE to declare YES or NO, chech you script again..."
                break
        ;;
esac




