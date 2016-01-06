#!/bin/bash

####created by jmbarros at tech4it dot com dot br                     ##### 
####free to distributing, just give me some credits, okay ? :)  
#### This script comes with ABSOLUTELY NO WARRANTY !!!                 #####
###########################################################################
#!/bin/bash
curl -OL https://github.com/softlayer/softlayer-python/zipball/master
unzip master
cd softlayer*
python setup.py install
echo " Now run slcli setup to create your credential at SLCLI " 
