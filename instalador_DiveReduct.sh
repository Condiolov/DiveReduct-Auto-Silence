#!/bin/bash 

chmod 744 ./divereduct.sh 

sudo rm /usr/share/kservices5/DiveReduct.desktop 

USER_HOME=$(eval echo ~${SUDO_USER})
echo "alias divereduct=\"$(pwd -P )/divereduct.sh\""  |& tee -a "${USER_HOME}/.bash_aliases"  

cp ./DiveReduct.desktop /usr/share/kservices5/DiveReduct.desktop




echo $(pwd -P )
#echo "${USER_HOME}/.bash_aliases"
