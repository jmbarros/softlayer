#!/bin/bash
###startup script for linux cloud machines
###created by jmbarros at tech4it.com.br
###free to distributing, just give me some credits, okay ? :)
###########################################################################
# this script will install a basic web server + php and the "Advanced Policy
# Firewal"

# Do you want to install the AFP in this server? This option is not mandatory
# but is very recomended, if you don't want install the APF just set the
# awnser above to NO.
# IF you want, you can adjust your TCP PORTS will accept connections to server
# in this ex. SSH,HTTP,HTTPS or 22,80,443 (no space btw ,)

INSTALL_AFP="YES"
PORTS="22,80,443"


# select from where you will download your web content from CDN or OBJECT STORAGE
# with you leave CDN URL blank, you HAVE to declare the OBJECT STORAGE URL, also you
# have to declare your CONTAINER,USER and PASSWORD to Object Storage connections work
# if you want use CDN anwser YES above, if you want use OBJECT STORAGE anwser NO

USE_CDN="YES"


# >>> enter the CDN URL that contains your web file (always use ZIP and don't forget the / (slash) in the end of URL)
cdn_url_webfile="http://15aa1.http.dal05.cdn.softlayer.net/models/"

# >>> file it contains you WEB (always use ZIP)
file="web.zip"

# OR enter your OBJECT STORAGE URL it contains your Web File (always use ZIP)
#the object storage requires the user and password, so take care about
#this file for not have your password expossed

# >>> enter the URL from your Object Storage that contains your web file (always use ZIP)
object_url="dal05.objectstorage.softlayer.net"

# >>> enter the name of CONTAINER
container="models"

# >>> file it contains you WEB (always use ZIP)
file="web.zip"

# >>> enter the softlayer object storage USER
user=""

# >>> enter the softlayer PASSWORD
password=""


############## FROM WHERE IS NOT NECESSARY YOUR INTERACTION #############
####### just change the script if you realy know what you're doing ######
#########################################################################
#create directory
mkdir $HOME/download_temp

#update linux (not necessary if used with own image)
yum -y update

#install applications
yum -y install httpd php wget

#config daemons to start automaticaly
chkconfig httpd on

#starting daemons
/etc/init.d/httpd start

#get your web packect in a object storage (one zip file with everything)

case $USE_CDN in
YES)
                echo "Using CDN..."
                wget -P $HOME/download_temp/ $cdn_url_webfile$file
        ;;
NO)
                echo "Using Object Storage..."
                #install Extra Packages Repo to download extra app
                yum -y install epel-release
                yum -y install sshpass
                yum -y remove epel-release
                export SSHPASS=$password
                sshpass -e sftp $user@$object_url:/$container/$file $HOME/download_temp/
                export SSHPASS="TO_LATE"
                yum -y remove sshpass
        ;;
*)
                echo "Do you didn't declare where is your web file correctly, please correct this before continue"
        ;;
esac

# copy the webfile for http directory
chmod +x $HOME/download_temp/$file
unzip $HOME/download_temp/$file -d /var/www/html
rm -rf $HOME/download_temp



#########################################################################
#######         INSTALL APF Firewall POLICY FOR WEB SERVER         ######
#########################################################################
case INSTALL_AFP in
        NO)
                exit
        ;;

        YES)
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

                #cleaning
                rm -rf $HOME/download_temp
        ;;
esac

