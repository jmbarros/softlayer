#!/bin/bash

####created by jmbarros at tech4it.com.br                              ##### 
####free to distributing, just give me some credits, okay ? :)  
#### This script comes with ABSOLUTELY NO WARRANTY !!!                 #####
###########################################################################

#check instance version
version=`python -c 'import yum, pprint; yb = yum.YumBase(); pprint.pprint(yb.conf.yumvar, width=1)' |grep uuid |cut -d"'" -f4`

#default versions
aws_6="5264c78d-4497-4a85-ae8d-09a60bf0e1de"
redhat_7="971d47ef-5f30-4e50-acac-b18a30a91e61"


#check version
if [ "$version" = "$aws_6" ]; then
        echo "Looks like a Amazon Linux AMI"
        version="AWS_6"
        export version_lin=$version
else
        echo "Sorry... I can't found this version of Linux"

        if [ "version" = "$redhat_7" ]; then
                echo "Looks like a RedHat Linux 7 for AWS"
        version="REDHAT_7"
        export version_lin=$version
        else
                echo "Sorry... I can't found this version of Linux"
                exit
        fi
fi