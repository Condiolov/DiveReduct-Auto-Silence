#!/bin/bash 

chmod 744 ./divereduct.sh 

sudo rm /usr/share/kservices5/DiveReduct.desktop 

sudo apt install python3-pip
pip3 install audiotsm
pip3 install scipy
pip3 install numpy
pip3 install Pillow
pip3 install pytube
sudo apt-get install ffmpeg
chmod 777 ./jumpcutter.py


USER_HOME=$(eval echo ~${SUDO_USER})
echo "alias divereduct=\"$(pwd -P )/divereduct.sh\""  |& tee -a "${USER_HOME}/.bash_aliases"  

cp ./DiveReduct.desktop /usr/share/kservices5/DiveReduct.desktop




echo $(pwd -P )
#echo "${USER_HOME}/.bash_aliases"
